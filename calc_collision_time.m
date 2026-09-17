% Calculating egg trajectory

egg_params = struct();
egg_params.a = 3;
egg_params.b = 2;
egg_params.c = .15;
y_ground = 0;
x_wall = 10;
[t_ground, t_wall] = collision_func(@egg_trajectory01, egg_params, y_ground, x_wall);



%Function that computes the collision time for a thrown egg
%INPUTS:
%traj_fun: a function that describes the [x,y,theta] trajectory
% of the egg (takes time t as input)
%egg_params: a struct describing the hyperparameters of the oval
%y_ground: height of the ground
%x_wall: position of the wall
%OUTPUTS:
%t_ground: time that the egg would hit the ground
%t_wall: time that the egg would hit the wall
function [t_ground,t_wall] = collision_func(traj_fun, egg_params, y_ground, x_wall)
    % relevant tolerances
    ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
    dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
    max_iter = 1000; % number of iterations per trial

    % times (left and right for bisection)
    t_left = 0;
    t_right = 100;

    % collision ground (y_ground)
    f_ground = @(t) ground_func(t, traj_fun, egg_params, y_ground);
    [t_ground, discarded_list, exit_flag] = bisection_solver(f_ground,t_left,t_right, dxtol, ftol, max_iter);

    % collision wall (x_ground)
    f_wall = @(t) wall_func(t, traj_fun, egg_params, x_wall);
    [t_wall, discarded_list, exit_flag] = bisection_solver(f_wall,t_left,t_right, dxtol, ftol, max_iter);
end


%Example parabolic trajectory
function [x0,y0,theta] = egg_trajectory01(t)
    x0 = 7*t + 8;
    y0 = -6*t.^2 + 20*t + 6;
    theta = 5*t;
end

function f_ground = ground_func(t, traj_fun, egg_params, y_ground)
    [x0,y0,theta] = traj_fun(t);
    [x_range, y_range] = compute_bounding_box_func(x0,y0,theta,egg_params);
    f_ground = y_range(1) - y_ground;  % when f_ground > 0: egg above ground | f_ground < 0: egg below ground

end

function f_wall = wall_func(t, traj_fun, egg_params, x_wall)

    [x0,y0,theta] = traj_fun(t);
    [x_range, y_range] = compute_bounding_box_func(x0,y0,theta,egg_params);
    f_wall = x_range(2) - x_wall; % when f_ground < 0: egg left of wall | when f_ground > 0: egg right of wall

end


%%% function from compute_bounding_box
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
