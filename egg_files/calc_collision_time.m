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
