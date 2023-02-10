function check_v(obj, t)
% show potential images from 2 sides

t = obj.model.to_time_dim(t);
 
sz = size(t, 2);
for ii = 1 : sz
    obj.t = t(ii);
    [psi, mu] = obj.get_itp();
    disp(['t = ', num2str(obj.model.to_time(obj.t)), ...
          ', mu = ', num2str(mu)]);

    subplot(3, sz, ii)
    %v = obj.get_v(t(ii));
    %value = 0.5*max(abs(psi(:)).^2);
    %p = patch(isosurface(obj.model.grid.r.x, ...
    %                     obj.model.grid.r.y, ...
    %                     obj.model.grid.r.z, abs(psi).^2, value));
    %hold on

    %alpha(0.1);
    %p.FaceColor = 'blue';
    %p.EdgeColor = 'none';
    %view(5, 25);

    %ylabel('y');
    %xlabel('x');
    %zlabel('z');
    %set(gca,'LineWidth', 3);
    %set(gca,'FontSize', 20);
    %[psi, mu] = obj.
    %subplot(3, sz, ii)
    %psi = (mu - obj.get_v(t(ii)))/obj.config.g;
    if obj.model.D == 3
        psixy = psi(:, :, obj.model.grid.N.z/2);
    elseif obj.model.D == 2
        psixy = psi;
    end

    imagesc(obj.model.grid.r.x, obj.model.grid.r.y, abs(psixy).^2)
    hold on
    xlabel('x')
    ylabel('y')
    colorbar;
    title(['t = ', num2str(obj.model.to_time(t(ii))), ' s']) 

    subplot(3, sz, ii + sz)
    imagesc(obj.model.grid.r.x, obj.model.grid.r.y, angle(psixy))
    hold on
    xlabel('x')
    ylabel('y')
    colorbar;
    clim([-pi, pi])
    title(['t = ', num2str(obj.model.to_time(t(ii))), ' s']) 

end
obj.t = 0;

[t1, t2, U1, U2] = obj.model.get_protocol_time();
Umax = 1.1*U2;
Umin = 1.1*U1;

subplot(3, sz, 2*sz + 1: 3*sz)
width = 1.2;
t = (t1:obj.model.to_time_dim(0.001):t2);
leg = {};
fields = fieldnames(obj.model.Vs);
for i = 1 : length(fields)
    field = fields{i};
    for j = 1 : length(obj.model.Vs.(field))
        v = obj.model.Vs.(field)(j);
        if abs(v.U.max) > 0 
            disp(field)
            disp(v.U.t)
            u = v.get_u(t);
            disp(max(u(:)))
            plot(obj.model.to_time(t), u, 'Linewidth', width)
            hold on
            leg{end + 1} = [field, num2str(j)];
        end
        if strcmp('toroidal', field)
                x1 = obj.model.to_time(v.tof(1));
                x2 = obj.model.to_time(v.tof(2));
                xBox = [x1, x1, x2, x2, x1];
                yBox = [Umin, Umax, Umax, Umin, Umin];
                patch(xBox, yBox, 'white', 'EdgeColor', 'white', 'FaceColor', 'blue', 'FaceAlpha', 0.1);
                hold on
                leg{end + 1} = [field, num2str(j), ' tof'];
        end
    end
end
legend(leg, 'Fontsize', 15, 'Location','north')
shg


end