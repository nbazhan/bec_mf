function [info] = get_info(obj)
    % gives string with all information about the system
    
    info = ['Dimensionless units:', newline, ...
            '----------------------', newline, ...
            '(lr , lz) = (', num2str(obj.model.l.r, '%.2g'), ', ', num2str(obj.model.l.z, '%.2g'), ') m', newline, ...
            '(wr , wz) = 2*pi*(', num2str(obj.model.w.r/(2*pi), '%.3g'), ', ', num2str(obj.model.w.z/(2*pi), '%.3g'), ') Hz', newline, ...
            'hwr = ', num2str(obj.model.config.hbar*obj.model.w.r, '%.3g'),  ' J', newline, ...
            'wr^-1 = ', num2str(1/obj.model.w.r, '%.2g'), ' s', newline, ...
            newline, ...
            'General configuration:', newline,...
            '----------------------', newline, ...
            num2str(obj.model.D), 'D problem', newline, ...
            'N = ', num2str(obj.model.config.N), ' of ', obj.model.config.che, ' atoms', newline, ...
            'gamma = ', num2str(obj.model.config.gamma), newline, ...
            'T = ', num2str(obj.model.to_temp(obj.model.config.T)), ' K', newline, ...
             newline, newline];

    fields = fieldnames(obj.model.Vs);
    for i = 1 : length(fields)
        field = fields{i};
        for j = 1 : size(obj.model.Vs.(field), 2)
            info = [info 'POTENTIAL ' field '-' num2str(j) ': ', newline, ...
                      '--------------------', newline];
            v = obj.model.Vs.(field)(j);


            if strcmp(field, 'toroidal')
                w =[v.w.r, v.w.z]/(2*pi);
                t = obj.model.to_time(v.U.t);
                tof = obj.model.to_time(v.tof);
                info = [info, ...
                'harm. frequencies: ', ...
                '(wr , wz) = 2*pi*(', num2str(w(1), '%.3g'), ', ', num2str(w(2), '%.3g'), ') Hz', newline, ...
                'potential form   : ', ...
                '(Rx, Ry) = (', num2str(v.R.x, '%.2f'), ', ', num2str(v.R.y, '%.2f') ') lr', ', ', ...
                'W = ', num2str(v.W), ' wr', newline, ...
                'ampl. protocol   : ', ...
                'U = ', num2str(v.U.max, '%.3g'), ' hwr', ', ', ...
                't = [', num2str(t(1)), ', ', num2str(t(2)), ', ', num2str(t(3)), ', ', num2str(t(4)), '] s', newline, ... 
                'rotating center  : ', ...
                '(x, y, rx, ry) = (', num2str(v.c.x, '%.2g'), ', ',  num2str(v.c.y, '%.2g'), ', ', ...
                                      num2str(v.c.rx, '%.2g'), ', ',  num2str(v.c.ry, '%.2g'), ') lr', ', ', ...
                'w = ', num2str(v.c.w, '%.3g'), ' wr', newline, ...
                'time of flight   : ',  ...
                't = [', num2str(tof(1)), ', ', num2str(tof(2)), '] s', newline, ... 
                 newline];
            end

        end
    end

 
    info = [info, newline, 'System parameters:', newline, ...
                  '------------------', newline, ...
                  '(Nx, Ny, Nz) = (', num2str(obj.model.grid.N.x), ', ', ...
                                      num2str(obj.model.grid.N.y), ', ', ...
                                      num2str(obj.model.grid.N.z), ')', newline, ...
                  '(Lx, Ly, Lz) = (', num2str(obj.model.grid.L.x), ', ', ...
                                      num2str(obj.model.grid.L.y), ', ', ...
                                      num2str(obj.model.grid.L.z), ') lr', newline, ...
                  'folder = ', obj.folder];
end


