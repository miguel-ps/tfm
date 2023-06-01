function plot_clusters_pca(class, coeff, seizure_win)

[~,coeff,~,~,~] = pca(coeff);

% Representación por colores
colores=lines(max(class));

figure
hold on
for i=1:size(class,1)
    if  (seizure_win(1) >0 && seizure_win(2)>0) && (i <= seizure_win(2) && i >= seizure_win(1))
        plot(coeff(i,1),coeff(i,2),'square','Color',colores(class(i),:))
    else
        plot(coeff(i,1),coeff(i,2),'.','Color',colores(class(i),:))
    end
end
xlabel('Componente 1')
ylabel('Componente 2')
title("Representación agrupamiento con "+num2str(length(unique(class)))+ " clusters")