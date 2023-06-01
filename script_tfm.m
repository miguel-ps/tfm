%% Cargar datos
rng default

clc, clear, close all

% Se almacena en una estructura los datos de la EEG
EEG = datos_EEG('Datos/chb05_06.edf', 'Datos/chb05-summary.txt');

%% Filtrado datos

%{
% Delay en segundos
D = 10;
% Orden del filtro
L  = 1024;
% Coeficiente de adaptación
mu = 1.0e-10;

EEG_filt = filtro_adaptativo(EEG,L,D,mu);

clear D L mu
%}

%% Método UMED

% Parámetros UMED
Lw = 1; % Longitud ventana en segundos
d = 1/2*Lw; % Step de la ventana en segundos
umbral_CCC = 0.85; % Umbral del valor CCC
n_ar_coeff = 2; % Numero coeficientes autorregresivos

CCC = [];

%---------------------------- CCC --------------------------------------
while true
    d = 1/2*Lw;
    % Cálculo de las señales segmentadas
    [EEG_win, ~, ~] = data_segmentation(EEG.datos, Lw, d, EEG.f_muestreo, EEG.t_inicio, EEG.t_fin);

    % Cálculo de características en cada ventana
    coeff = AR_burg(EEG_win, n_ar_coeff);

    % Cálculo CCC
    CCC(end+1) = calculo_CCC(coeff);

    if CCC(end) == max(CCC)
        Lw_0 = Lw;
    end

    if max(CCC) >= umbral_CCC 
        break
    else
        Lw = Lw + 0.5;
    end
end

clear AR_coeff score explained n_comp Lw d
%% Cálculo s_DBW
%--------------------------- s_DBW -------------------------------------
% Aumento ventana en segundos
D_L = 1;
% Número de veces que se aumenta la ventana
N_L = 15;
% Número máximo de clusters
NG = 30;

for Lw_i = Lw_0:D_L:Lw_0+D_L*N_L
        d = 1/2*Lw_i;
        [EEG_win, ~, ~] = data_segmentation(EEG.datos, Lw_i, d, EEG.f_muestreo, EEG.t_inicio, EEG.t_fin);
        
        % Cálculo de características en cada ventana
        coeff = AR_burg(EEG_win, n_ar_coeff);

        % Cálculo sDBW
        [sDBW{(Lw_i-Lw_0)/D_L+1}, clust{(Lw_i-Lw_0)/D_L+1}, CCC_sdbw{(Lw_i-Lw_0)/D_L+1}] = calculo_s_DBW_jerarquico(coeff, NG);
end

% Calcular el mínimo y seleccionarlo

[s_DBW_min, aux] = min(cellfun(@min,sDBW));
N_0 = find(sDBW{aux} == s_DBW_min)+1;
Lw_H = (aux-1)*D_L + Lw_0;

clear aux
%% Agrupamientos
% ------------------- Hierarchichal clustering y k-means ---------------
d = 1/2*Lw_H;
[EEG_win, n_win, seizure_win] = data_segmentation(EEG.datos, Lw_H, d, EEG.f_muestreo, EEG.t_inicio, EEG.t_fin);

% Cálculo de características en cada ventana
%coeff = AR_burg(EEG_win, n_ar_coeff);
%coeff = PSD_coeff(EEG_win, EEG.f_muestreo);
%coeff = DWT_coeff(EEG_win);
%coeff = no_lineales_coeff(EEG_win);
coeff = time_coeff(EEG_win);

P = pdist(coeff);

metodos_linkado = {'single', 'complete', 'average', ...
                    'ward', 'weighted'};

for i=1:length(metodos_linkado)
    Z(:,:,i)=linkage(P,metodos_linkado{i});
    coph(i)=cophenet(Z(:,:,i),P);
end

%Selección de la distancia con cophenet más alto
[~, ind] = max(coph);
j_class=cluster(Z(:,:,ind(1)),'maxclust',N_0);

[k_class, k_centroids] = kmeans(coeff, N_0, 'Replicates', 500);
%% Valor de Silhouette
% ------------------- Evalución clusters -------------------------------

eval_hierarchical = evalclusters(coeff, 'linkage', 'Silhouette', 'KList', N_0);
values_linkage = eval_hierarchical.CriterionValues';

eval_kmeans = evalclusters(coeff, 'kmeans', 'Silhouette', 'KList', N_0);
values_kmeans = eval_kmeans.CriterionValues';

clear eval_hierarchical eval_kmeans
%% Gráfico de los clusters
plot_clusters_pca(j_class, coeff, seizure_win);
plot_clusters_pca(k_class, coeff, seizure_win);

%% Evaluación

% Evaluación FP FN TP TN
[TP, TN, FP, FN] = evaluation(j_class, seizure_win, coeff);
jerarquico_accuracy = (TP+TN)/(TP+TN+FP+FN)
jerarquico_sensitivity = TP/(TP+FN)
jerarquico_specifity = TN/(TN+FP)

[TP_k, TN_k, FP_k, FN_k] = evaluation(k_class, seizure_win, coeff);
k_accuracy = (TP_k+TN_k)/(TP_k+TN_k+FP_k+FN_k)
k_sensitivity = TP_k/(TP_k+FN_k)
k_specifity = TN_k/(TN_k+FP_k)
%% Dibujar señal EEG con los intervalos calculados

plot_regions(EEG, seizure_win, Lw_H, d, N_0, CCC_sdbw{(Lw_H-Lw_0)/D_L+1}, j_class, s_DBW_min);
plot_regions(EEG, seizure_win, Lw_H, d, N_0, CCC_sdbw{(Lw_H-Lw_0)/D_L+1}, k_class, s_DBW_min);
%% Clustering referencia

EEG_2 = datos_EEG('Datos/chb05_13.edf', 'Datos/chb05-summary.txt');

d = 1/2*Lw_H;
[EEG_2_win, n_2_win, seizure_2_win] = data_segmentation(EEG_2.datos, Lw_H, d, EEG_2.f_muestreo, EEG_2.t_inicio, EEG_2.t_fin);

% Cálculo de características en cada ventana
%coeff_2 = AR_burg(EEG_2_win, n_ar_coeff);
%coeff_2 = PSD_coeff(EEG_2_win, EEG_2.f_muestreo);
%coeff_2 = DWT_coeff(EEG_2_win);
%coeff_2 = no_lineales_coeff(EEG_2_win);
coeff_2 = time_coeff(EEG_2_win);

clust_2 = cluster_referencia(coeff_2, j_class, coeff);

% Clusters
plot_clusters_pca(clust_2, coeff_2, seizure_2_win);

% Evaluación FP FN TP TN
[TP, TN, FP, FN] = evaluation(clust_2, seizure_2_win, coeff_2);
accuracy_2 = (TP+TN)/(TP+TN+FP+FN)
sensitivity_2 = TP/(TP+FN)
specifity_2 = TN/(TN+FP)

% Gráfica
plot_regions(EEG_2, seizure_2_win, Lw_H, d, N_0, CCC_sdbw{(Lw_H-Lw_0)/D_L+1}, clust_2, s_DBW_min);