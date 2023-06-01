function NL_coeff = no_lineales_coeff(data_win)
NL_coeff = zeros(size(data_win,3), size(data_win,2)*5);

for win=1:size(data_win,3)

    % Entropía Shannon
    for j=1:size(data_win,2)
        NL_coeff(win,j) = wentropy(data_win(:,j,win),'shannon');
    end

    % Hurst exponent
    for j=1:size(data_win,2)
        NL_coeff(win,size(data_win,2)+j) = hurst_exponent(data_win(:,j,win)');
    end

    % Hjorth parameters
    [NL_coeff(win,2*size(data_win,2)+1:2*size(data_win,2)+size(data_win,2)), NL_coeff(win,3*size(data_win,2)+1:3*size(data_win,2)+size(data_win,2)), NL_coeff(win,4*size(data_win,2)+1:4*size(data_win,2)+size(data_win,2))] = hjorth(data_win(:,:,win));

end
end

function [ACTIVITY, MOBILITY, COMPLEXITY] = hjorth(win)
    [~,ch] = size(win);
    %m0 = mean(sumsq(S,2));
    d0 = win;
    %m1 = mean(sumsq(diff(S,[],1),2));
    d1 = diff([zeros(1,ch);win],[],1);
    d2 = diff([zeros(1,ch);d1],[],1);
    
    m0 = mean(d0.^2);
    m1 = mean(d1.^2);
    m2 = mean(d2.^2);
    
    ACTIVITY   = m0;
    MOBILITY   = sqrt(m1./m0); 
    COMPLEXITY = sqrt(m2./m1)./MOBILITY; 
end