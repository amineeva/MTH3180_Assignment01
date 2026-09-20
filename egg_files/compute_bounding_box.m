% Egg Step 1! Plots egg with bounding box. Bounding box functions included
% in file

egg_params = struct();
egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
%specify the position and orientation of the egg
x0 = 5; y0 = 5; theta = pi;
hold on; axis equal; axis square
axis([0,10,0,10])
%plot the origin of the egg frame
plot(x0,y0,'ro','markerfacecolor','r');
%compute the perimeter of the egg
[V_list, G_list] = egg_func(linspace(0,1,100),x0,y0,theta,egg_params);
%plot the perimeter of the egg
plot(V_list(1,:),V_list(2,:),'k');
%compute the bounding box
[x_range, y_range] = compute_bounding_box_func(x0, y0, theta, egg_params);

% bounding box coordinates from ranges
x_box = [x_range(1),x_range(2),x_range(2),x_range(1),x_range(1)];
y_box = [y_range(1),y_range(1),y_range(2),y_range(2),y_range(1)];

% plot the bounding box
plot(x_box,y_box,'c');

%%%%%% Functions for bounding box and first wrapper function


%Function that computes the bounding box of an oval
    %INPUTS:
    %theta: rotation of the oval. theta is a number from 0 to 2*pi.
    %x0: horizontal offset of the oval
    %y0: vertical offset of the oval
    %egg_params: a struct describing the hyperparameters of the oval
    %OUTPUTS:
    %x_range: the x limits of the bounding box in the form [x_min,x_max]
    %y_range: the y limits of the bounding box in the form [y_min,y_max]


%wrapper function that calls egg_func
%and only returns the x coordinate of the
%point on the perimeter of the egg
%(single output)
function x_out = egg_wrapper1(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    x_out = V(1);
end


% return dx/ds to for bounding box
function dxds_out = egg_dx_wrapper(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    dxds_out = G(1);
end

% return dy/ds to for bounding box
function dyds_out = egg_dy_wrapper(s,x0,y0,theta,egg_params)
    [V, G] = egg_func(s,x0,y0,theta,egg_params);
    dyds_out = G(2);
end

function [x_range,y_range] = compute_bounding_box_func(x0,y0,theta,egg_params)

    % relevant tolerances
    ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
    dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
    dxmax = 1e14;
    max_iter = 1000; % number of iterations per trial

    % need dxds and dyds as a function of s ONLY (1input-1output)
    dxds_wrapper = @(s) egg_dx_wrapper(s,x0,y0,theta,egg_params);
    dyds_wrapper = @(s) egg_dy_wrapper(s,x0,y0,theta,egg_params);

    % Find roots for dx/ds and dy/ds. Know we have 4 points so splitting s
    % into 4 sections: (0, 0.25, 0.5, 0.75, 1)

    %%% s values where the solver finds dx/ds = 0
    s_x1 = secant_solver(dxds_wrapper, 0, 0.25, dxtol, ftol, max_iter, dxmax);
    s_x2 = secant_solver(dxds_wrapper, 0.25, 0.5, dxtol, ftol, max_iter, dxmax);
    s_x3 = secant_solver(dxds_wrapper, 0.5, 0.75, dxtol, ftol, max_iter, dxmax);
    s_x4 = secant_solver(dxds_wrapper, 0.75, 1, dxtol, ftol, max_iter, dxmax);

    %%% s values where the solver finds dy/ds = 0
    s_y1 = secant_solver(dyds_wrapper, 0, 0.25, dxtol, ftol, max_iter, dxmax);
    s_y2 = secant_solver(dyds_wrapper, 0.25, 0.5, dxtol, ftol, max_iter, dxmax);
    s_y3 = secant_solver(dyds_wrapper, 0.5, 0.75, dxtol, ftol, max_iter, dxmax);
    s_y4 = secant_solver(dyds_wrapper, 0.75, 1, dxtol, ftol, max_iter, dxmax);
    
    % now need to turn the 's' coordinate into x and y coordinates for
    % bound box -> need the 'V' coordinate of x/y component
    s_x = [s_x1, s_x2, s_x3, s_x4];
    % passing 's' value vector for matrix of x(s), y(s) values -> care
    % about top row (x-vals) of V_x
    [V_x, G_x] = egg_func(s_x, x0, y0, theta, egg_params);

    s_y = [s_y1, s_y2, s_y3, s_y4];
    % passing 's' value vector for matrix of x(s), y(s) values -> care
    % about bottom row (y-vals) of V_y
    [V_y, G_y] = egg_func(s_y, x0, y0, theta, egg_params);

    % now find the min and max x-vals (left and right edges)
    x_min = min(V_x(1,:)); % left-most point
    x_max = max(V_x(1,:)); % right-most point
    x_range = [x_min, x_max];

    % now find the min and max y-vals (bottom and top edges)
    y_min = min(V_y(2,:)); % bottom point
    y_max = max(V_y(2,:)); % top point
    y_range = [y_min, y_max];

end
