function clust=cluster_referencia(coeff_2, clust_ref, coeff)

clust = zeros(size(coeff_2,1),1);
for win_2 = 1:size(coeff_2,1)
    D = zeros(size(coeff,1),1);
    car_1 = coeff_2(win_2,:);
    for win = 1:size(coeff,1)
        car_2 = coeff(win,:);
        D(win) = sqrt(sum(car_1-car_2).^2);
    end

    [~, ind] = min(D);
    clust(win_2) = clust_ref(ind);
end

end