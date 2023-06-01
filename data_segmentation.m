function [W, Nw, seizure_windows] = data_segmentation(EEG, L, S, f_muestreo,t_inicio,t_fin)
    % Longitud
    Lw = L*f_muestreo;
    % Step
    Sw = S*f_muestreo;
    % Número ventanas
    Nw = floor((size(EEG,1)-(Lw))/Sw)+1;
    % Ventanas en las que empieza y termina el ataque
    seizure_windows = zeros(1,2);

    W = zeros(Lw,size(EEG,2),Nw);

    
        for ch=1:size(EEG,2)
            for i=1:Nw
                W(:,ch,i) = EEG((i-1)*Sw+1:((i-1)*Sw)+Lw,ch);
            
                if ((i-1)*Sw+1 >= t_inicio*256 && seizure_windows(1) == 0) && (ch == size(EEG,2) && t_inicio>0)
                    seizure_windows(1) = i;
                elseif (((i-1)*Sw)+Lw <= t_fin*256 && seizure_windows(1) ~= 0) && (ch == size(EEG,2) && t_inicio>0)
                    seizure_windows(2) = i;
                end
    
            end
        end
    
        if seizure_windows(2) == 0 && t_inicio > 0
            seizure_windows(2) = seizure_windows(1);
        end
end