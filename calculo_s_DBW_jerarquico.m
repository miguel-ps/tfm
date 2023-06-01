function [s_Dbw, T, CCC]=calculo_s_DBW_jerarquico(F, NG)
    P = pdist(F);

    metodos_linkado = {'single', 'complete', 'average', ...
                        'ward', 'weighted'};

    for i=1:length(metodos_linkado)
        Z(:,:,i)=linkage(P,metodos_linkado{i});
        coph(i)=cophenet(Z(:,:,i),P);
    end

    %Selección de la distancia con cophenet más alto
    [CCC, ind] = max(coph);

    %Contenido de los clusters:
    for i = 2:1:NG
        T{i-1}=cluster(Z(:,:,ind(1)),'maxclust',i);
        s_Dbw(i-1) = s_dbw(T{i-1},F);
    end
    
    %{
    [s_Dbw, ind] = min(s_Dbw);
    clust = T{ind(1)};
    %}
end
