function CCC = calculo_CCC(coeff)
    P = pdist(coeff);

    metodos_linkado = {'single', 'complete', 'average', ...
                        'ward', 'weighted'};

    for i=1:length(metodos_linkado)
        Z(:,:,i)=linkage(P,metodos_linkado{i});
        coph(i)=cophenet(Z(:,:,i),P);
    end

    %Selección de la distancia con cophenet más alto
    [CCC, ind] = max(coph);
end