function s_Dbw =calculo_s_DBW_kmeans(F, NG)

    %Contenido de los clusters:
    for i = 2:1:NG
        [class, ~] = kmeans(F, i, 'Replicates', 10);
        s_Dbw(i-1) = s_dbw(class,F);
    end

end