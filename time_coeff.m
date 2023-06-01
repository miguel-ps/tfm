function time_coeff = time_coeff(data_win)

    time_coeff = zeros(size(data_win,3), size(data_win,2)*4);

    for win=1:size(data_win,3)
        % Energía
        time_coeff(win, 0*size(data_win,2)+1:1*size(data_win,2)) = (rms(data_win(:,:,win)).^2).*size(data_win,1);

        % Máximo
        time_coeff(win, 1*size(data_win,2)+1:2*size(data_win,2)) = max(data_win(:,:,win));

        % Mínimo
        time_coeff(win, 2*size(data_win,2)+1:3*size(data_win,2)) = min(data_win(:,:,win));

        % Número máximos locales
        for i=1:size(data_win,2)
            aux{i} = findpeaks(data_win(:,i,win))';
            aux2(i) = length(aux{i});
        end
        time_coeff(win, 3*size(data_win,2)+1:4*size(data_win,2)) = aux2;
    end
end

function NE=non_linear_energy(win)
    aux = zeros(1,size(win,2));
    for i=2:size(win,1)-1
        aux = aux + win(i,:).^2 - win(i+1,:).*win(i-1,:);
    end
    NE = aux;
end