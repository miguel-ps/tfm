function y_out=filtro_adaptativo(EEG, L, D, mu)

    y_out = zeros(size(EEG.datos));

    for ch = 1:size(EEG.datos,2)
        LMSFilter = dsp.LMSFilter('Length',L,'StepSize',mu,'Method', 'LMS');
        s = EEG.datos(:,ch);
        
        delay = dsp.Delay(D*EEG.f_muestreo);
        x = delay(s);
        d=s;
        y_out(:,ch) = LMSFilter(x,d);
    end
end