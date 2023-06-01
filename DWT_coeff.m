function DWT_coeff = DWT_coeff(data_win)

% Nivel dwt
n = 4;
onda = 'db4';

% Parametros dwt
nivel = zeros(n+1,1);
nivel(1) = size(data_win,1);

for i=2:n+1
    nivel(i) = floor((nivel(i-1)-1)/2)+4;
end

DWT_coeff = zeros(size(data_win,3), size(data_win,2)*4*4);
% DWT
for win=1:size(data_win,3)

    coeff_dwt = zeros(sum(nivel(2:end))+nivel(end), size(data_win,2));
    % 5 niveles --> 5 detalle 1 aprox
    a4 = zeros(nivel(end),size(data_win,2));
    d1 = zeros(nivel(2),size(data_win,2));
    d2 = zeros(nivel(3),size(data_win,2));
    d3 = zeros(nivel(4),size(data_win,2));
    d4 = zeros(nivel(5),size(data_win,2));

    for j = 1:size(data_win,2)
        [coeff_dwt(:,j), l] = wavedec(data_win(:,j,win), n, onda);
        a4(:,j) = appcoef(coeff_dwt(:,j),l,onda);
        [d1(:,j), d2(:,j), d3(:,j), d4(:,j)] = detcoef(coeff_dwt(:,j),l,[1,2,3,4]);
    end

    % Máximo
    DWT_coeff(win,1:size(data_win,2)) = max(d1);
    DWT_coeff(win,size(data_win,2)+1:2*size(data_win,2)) = max(d2);
    DWT_coeff(win,2*size(data_win,2)+1:3*size(data_win,2)) = max(d3);
    DWT_coeff(win,3*size(data_win,2)+1:4*size(data_win,2)) = max(d4);
    DWT_coeff(win,4*size(data_win,2)+1:5*size(data_win,2)) = max(a4);

    % Mínimo
    DWT_coeff(win,6*size(data_win,2)+1:7*size(data_win,2)) = min(d1);
    DWT_coeff(win,7*size(data_win,2)+1:8*size(data_win,2)) = min(d2);
    DWT_coeff(win,8*size(data_win,2)+1:9*size(data_win,2)) = min(d3);
    DWT_coeff(win,9*size(data_win,2)+1:10*size(data_win,2)) = min(d4);
    DWT_coeff(win,10*size(data_win,2)+1:11*size(data_win,2)) = min(a4);
    
    % Energía
    DWT_coeff(win,12*size(data_win,2)+1:13*size(data_win,2)) = (rms(d1).^2).*size(data_win,1);
    DWT_coeff(win,13*size(data_win,2)+1:14*size(data_win,2)) = (rms(d2).^2).*size(data_win,1);
    DWT_coeff(win,14*size(data_win,2)+1:15*size(data_win,2)) = (rms(d3).^2).*size(data_win,1);
    DWT_coeff(win,15*size(data_win,2)+1:16*size(data_win,2)) = (rms(d4).^2).*size(data_win,1);
    DWT_coeff(win,16*size(data_win,2)+1:17*size(data_win,2)) = (rms(a4).^2).*size(data_win,1);

    % Energía no lineal
    DWT_coeff(win,18*size(data_win,2)+1:19*size(data_win,2)) = non_linear_energy(d1);
    DWT_coeff(win,19*size(data_win,2)+1:20*size(data_win,2)) = non_linear_energy(d2);
    DWT_coeff(win,20*size(data_win,2)+1:21*size(data_win,2)) = non_linear_energy(d3);
    DWT_coeff(win,21*size(data_win,2)+1:22*size(data_win,2)) = non_linear_energy(d4);
    DWT_coeff(win,22*size(data_win,2)+1:23*size(data_win,2)) = non_linear_energy(a4);

end
    DWT_coeff(isnan(DWT_coeff)) = 0;
end

function NE=non_linear_energy(win)
    aux = zeros(1,size(win,2));
    for i=2:size(win,1)-1
        aux = aux + win(i,:).^2 - win(i+1,:).*win(i-1,:);
    end
    NE = aux;
end

function line_length(win)

end