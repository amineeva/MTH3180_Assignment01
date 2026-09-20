%example of how to test the bounding box function
function bounding_box_test()
    clear;
    %set the oval hyper-parameters
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    %specify the position and orientation of the egg
    x0 = 5; y0 = 5; theta = pi/6;

    %set up the axis
    hold on; axis equal; axis square
    axis([0,10,0,10])

    %plot the origin of the egg frame
    plot(x0,y0,'ro','markerfacecolor','r');

    %compute the perimeter of the egg
    [V_list, G_list] = egg_func(linspace(0,1,100),x0,y0,theta,egg_params);

    %plot the perimeter of the egg
    plot(V_list(1,:),V_list(2,:),'k');
    
    %compute the bounding box of the egg
    [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)

    %plot the bounding box of the egg
    plot([x_range(1), x_range(1)], [y_range(1), y_range(2)], 'b-')
    plot([x_range(1), x_range(2)], [y_range(2), y_range(2)], 'b-')
    plot([x_range(2), x_range(2)], [y_range(2), y_range(1)], 'b-')
    plot([x_range(2), x_range(1)], [y_range(1), y_range(1)], 'b-')
    hold off
end

% Function that computes the bounding box of an oval
%
% INPUTS:
% theta: rotation of the oval
% x0: horizontal offset of the oval
% y0: vertical offset of the oval
% egg_params: struct describing the hyperparameters of the oval
%
% OUTPUTS:
% x_range: x limits of bounding box [x_min,x_max]
% y_range: y limits of bounding box [y_min,y_max]

function [x_range,y_range] = compute_bounding_box(x0,y0,theta,egg_params)

    ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
    dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
    dxmax = 1e14;
    max_iter = 100;
    num_iter = max_iter;

    %you'll need to change this
    %you might even need multiple guesses
    %so that you can catch top/bottom/left/right points of egg
    %with multiple guesses, you will probably need a for loop!
    s_guess = linspace(0, 0.5, 201) ;
    s_guess2 = linspace(0.5, 1, 201);

    xfunc = @(s) eggwrapperx(s,x0,y0,theta,egg_params);
    yfunc = @(s) eggwrappery(s,x0,y0,theta,egg_params);

    % Find x extrema
    x_roots = [];

    for n = 1:length(s_guess)
        x_root = secant_solver(xfunc, s_guess(n), s_guess2(n), dxtol,ftol,max_iter,dxmax);
        x_roots = [x_roots, x_root];
    end

    y_roots = [];

    for n = 1:length(s_guess)
        y_root = secant_solver(yfunc, s_guess(n), s_guess2(n), dxtol,ftol,max_iter,dxmax);
        y_roots = [y_roots, y_root];
    end

    % Evaluate points at extrema
    [Vx,~] = egg_func(x_roots,x0,y0,theta,egg_params);
    [Vy,~] = egg_func(y_roots,x0,y0,theta,egg_params);

    % Bounding box
    x_range = [min(Vx(1,:)),max(Vx(1,:))];
    y_range = [min(Vy(2,:)),max(Vy(2,:))];

end


% Returns x-component of gradient
function xout = eggwrapperx(s, x0,y0,theta,egg_params)
    [V,G] = egg_func(s, x0, y0, theta, egg_params);
    xout = G(1);
end

function yout = eggwrappery(s, x0, y0, theta, egg_params)
    [V,G] = egg_func(s, x0, y0, theta, egg_params);
    yout = G(2);
end

    x = x_n;
end

