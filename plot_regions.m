function plot_regions(EEG, seizure_win, Lw, d, N_0, CCC, class, s_DBW_min)

c = hsv(N_0);

current_group = class(1);
intervals = ones(1,3);
intervals(1,1) = 0;
intervals(1,3) = class(1);
i_intervals = 1;
for i = 1:length(class)
    if current_group ~= class(i)
        if (i - 1)*d + 6*Lw/7 + d/2 > EEG.tiempo(end)
            intervals(i_intervals,2) = EEG.tiempo(end);
        else
            intervals(i_intervals,2) = (i - 1)*d;
        end
        i_intervals = i_intervals + 1;
        intervals(i_intervals,1) = (i - 1)*d;
        intervals(i_intervals,3) = class(i);
        current_group = class(i);
    end
end

intervals(i_intervals,2) = EEG.tiempo(end);

figure
hold on
for i = 1:size(intervals,1)
    patch([(intervals(i,1)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,2)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,2)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,1)*EEG.f_muestreo)/EEG.f_muestreo], [24 24 0 0], c(intervals(i,3),:))
end
for i = 1:size(EEG.datos,2)
    plot(EEG.tiempo, EEG.datos(:,i)/1000 + i ,'k')
end

if seizure_win(1)>0 && seizure_win(2)>0
    xline((seizure_win(1)-1)*d*EEG.f_muestreo/EEG.f_muestreo,'g-.','LineWidth',2)
    xline((seizure_win(2))*d*EEG.f_muestreo/EEG.f_muestreo,'g-.','LineWidth',2)
end
title({"Lw = " + num2str(Lw) + "; d = " + num2str(d) + "; Num de clusters: " + num2str(N_0) + "; CCC: "+ num2str(CCC)}+"; s_DBW:" + num2str(s_DBW_min));

hold off

axis([0, EEG.n_segundos, 0, size(EEG.datos,2)]);

if seizure_win(1)>0 && seizure_win(2)>0
    figure 
    hold on
    for i = 1:size(intervals,1)
        patch([(intervals(i,1)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,2)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,2)*EEG.f_muestreo)/EEG.f_muestreo (intervals(i,1)*EEG.f_muestreo)/EEG.f_muestreo], [24 24 0 0], c(intervals(i,3),:))
    end
    for i = 1:size(EEG.datos,2)
        plot(EEG.tiempo, EEG.datos(:,i)/1000 + i ,'k')
    end
    
    xline((seizure_win(1)-1)*d*EEG.f_muestreo/EEG.f_muestreo,'g-.','LineWidth',2)
    xline((seizure_win(2))*d*EEG.f_muestreo/EEG.f_muestreo,'g-.','LineWidth',2)
    title({"Lw = " + num2str(Lw) + "; d = " + num2str(d) + "; Num de clusters: " + num2str(N_0) + "; CCC: "+ num2str(CCC)}+"; s_DBW:" + num2str(s_DBW_min));
    hold off
    axis([EEG.t_inicio-(EEG.t_fin-EEG.t_inicio), EEG.t_fin+(EEG.t_fin-EEG.t_inicio), 0, size(EEG.datos,2)]);
end
end