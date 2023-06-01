function AR_coeff = AR_burg(data_win, n_coeff)

    AR_coeff = zeros(size(data_win,3), n_coeff*size(data_win,2));

    for ch=1:size(data_win,2)
        for win=1:size(data_win,3)
            AR_temp = arburg(data_win(:,ch,win),n_coeff);
            AR_coeff(win, (n_coeff*ch-(n_coeff - 1)):(n_coeff*ch)) = AR_temp(2:end);
        end
    end
end