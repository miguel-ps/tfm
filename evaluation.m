function [TP, TN, FP, FN] = evaluation(class, seizure_windows, coeff)

seizure = zeros(length(class),1);
for i = 1:length(class)
    if (i >= seizure_windows(1) && i <= seizure_windows(2))
        seizure(i) = 1;
    end
end

detection = zeros(length(class),1);

clusters_seizure = zeros(max(class),1);

if seizure_windows(1)>0 && seizure_windows(2)>0
    for cluster = 1:max(class)
        if (sum(class(seizure_windows(1):seizure_windows(2)) == cluster) / sum(class == cluster) >= 0.4)
            clusters_seizure(cluster) = 1;
        end
    end
    
    for i = 1:length(class)
        if (clusters_seizure(class(i)) == 1)
            detection(i) = 1;
        end
    end
end

TP = 0;
TN = 0;
FP = 0;
FN = 0;

figure 
[~,coeff,~,~,~] = pca(coeff);

for i = 1:length(class)
    if (seizure(i) == 1 && detection(i) == 1)
        TP = TP + 1;
        plot(coeff(i,1),coeff(i,2),'*','Color','r')
    elseif (seizure(i) == 0 && detection(i) == 0)
        TN = TN + 1;
        plot(coeff(i,1),coeff(i,2),'*','Color','g')
    elseif (seizure(i) == 1 && detection(i) == 0)
        FN = FN + 1;
        plot(coeff(i,1),coeff(i,2),'*','Color','m')
    elseif (seizure(i) == 0 && detection(i) == 1)
        FP = FP + 1;
        plot(coeff(i,1),coeff(i,2),'*','Color','y')
    end
    hold on
end

xlabel('Componente 1')
ylabel('Componente 2')
title('Evaluación del agrupamiento')
hold off

end