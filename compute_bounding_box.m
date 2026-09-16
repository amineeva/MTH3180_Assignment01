% Egg Step 1!

% egg_func for egg_func 


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
function [x_range,y_range] = compute_bounding_box_func(x0,y0,theta,egg_params)
   % Wrapper function 2 (step 3)
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;
    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;
    %wrapper function that calls egg_wrapper1
    %but only takes s as an input (other inputs are fixed)
    %(single input)
    egg_wrapper2 = @(s) egg_wrapper1(s,x0,y0,theta,egg_params);
    
    
    %compute the value of s for which the corresponding point on the oval
    %has an x-coordinate of zero
    ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
    dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
    dxmax = 1e14;
    max_iter = 1000; % number of iterations per trial
    num_iter = 1000; % number of trials we would like to perform

    % need to find 4 roots using secant_solver -> between 0, 1/3, 2/3, 3/3
    for n = 1:num_trials

    % Pull out the initial guesses for this trial
    x0 = X(n);
    x1 = Y(n);

    % Reset recorder
    my_recorder.clear_input_list();

    % Call Secant solver
    x_root = secant_solver( ...
        f_record, x0, x1, dxtol, ftol, max_iter, dxmax);

    % Get recorded inputs
    input_list = my_recorder.get_input_list();

    % Need at least two recorded points to create e_n and e_(n+1)
    if length(input_list) >= 2

        x_current_list = ...
            [x_current_list, input_list(1:end-1)];

        x_next_list = ...
            [x_next_list, input_list(2:end)];

        index_list = ...
            [index_list, 1:length(input_list)-1];

    end
    




    s_root = secant_solver(egg_wrapper2,0,0.33, dxtol, ftol, num_iter, dxmax);





end


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