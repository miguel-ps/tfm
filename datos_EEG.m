function EEG = datos_EEG(nombre_archivo, sumario)
    datos= edfread(nombre_archivo);
    info = edfinfo(nombre_archivo);
    
    C = readcell(sumario);
    
    EEG.channels = 1:1:size(datos,2);
    
    EEG.f_muestreo = info.NumSamples/seconds(info.DataRecordDuration);
    EEG.f_muestreo = EEG.f_muestreo(1);
    
    [fila,~] = find(strcmp(C,info.Filename));

    [fila_n, ~] = find(strcmp(C(fila:end,:),'Number of Seizures in File'),1);
    n_seizures = C{fila+fila_n-1,2};

    if n_seizures > 0
        [fila_ti, col_ti] =find(strcmp(C(fila:end,:),'Seizure Start Time'),1);
        [fila_tf, col_tf] =find(strcmp(C(fila:end,:),'Seizure End Time'),1);
    
        if isempty(fila_ti)
            [fila_ti, col_ti] =find(strcmp(C(fila:end,:),"Seizure 1 Start Time"),1);
            [fila_tf, col_tf] =find(strcmp(C(fila:end,:),"Seizure 1 End Time"),1);
        end
        
        EEG.t_inicio = split(C{fila+fila_ti-1, col_ti+1});
        EEG.t_fin = split(C{fila+fila_tf-1, col_tf+1});
        
        EEG.t_inicio = str2double(EEG.t_inicio{1});
        EEG.t_fin = str2double(EEG.t_fin{1});
    else
        EEG.t_inicio = -1;
        EEG.t_fin = -1;
    end
    
    clear fila fila_ti fila_tf columna_ti columna_tf
    
    EEG.n_segundos = info.NumDataRecords;
    EEG.datos = zeros(EEG.f_muestreo*EEG.n_segundos, length(EEG.channels));
    
    EEG.tiempo = linspace(0,EEG.n_segundos,EEG.f_muestreo*EEG.n_segundos)';
    
    for ch=1:1:length(EEG.channels)
            EEG.datos(:,ch) = cell2mat(datos.(EEG.channels(ch))(:));
    end
end