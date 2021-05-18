function [dio] = exp_init_ni_dio(experiment)

lines_id        = strcat(num2str(0),':',num2str(experiment.io.ch_num - 1));
port_id         = experiment.io.ni.port_id;
data_direction  = experiment.io.ni.data_direction;
port_str        = strcat('Port',num2str(port_id)  ,'/','Line', lines_id);
device_id       = experiment.io.ni.device_id;

if strcmp(experiment.sys.matlab_ver, 'win32')
    hw_info     = daqhwinfo;
    str_name    = 'nidaq';
    % Search nidaq device
    N_device    = length(hw_info.InstalledAdaptors);
    for j = 1:N_device
        if strcmp(hw_info.InstalledAdaptors{j},str_name)
            disp('NI-daq found ok')
            ni_info     = daqhwinfo(str_name);
            str_dev     = ni_info.InstalledBoardIds{device_id};
            % Digital output
            dio         = digitalio(str_name,str_dev);
            hwlines     = addline(dio,str2num(lines_id),port_id,data_direction);
            %hwlines    = addline(dio,0,1,'out');
            flag_ni     = 1;
        end
    end
    
    if ~(flag_ni)
        disp('NI-daq not found ok')
        dio = 0;
    end
    
else
    hw_info = daq.getDevices;
    if ~isempty(hw_info)
        disp('NI-daq found ok')
        ni_obj  = hw_info(device_id);
        id_Dev  = ni_obj.ID;
        dio     = daq.createSession('ni');
        
        %initialization output lines
        dio.addDigitalChannel(id_Dev, port_str, data_direction)
        ... s.addDigitalChannel(id_Dev,'Port0/Line0:1',)
            %%Generate digital data
        data_values = zeros(1,experiment.io.ch_num);
        ... data_values = zeros(1,2);
        dio.outputSingleScan(data_values)
        
    else
        disp('National Instruments Board NOT found');
        dio = 0;
        return
    end
end
