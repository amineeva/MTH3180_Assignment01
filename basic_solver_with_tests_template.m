%template for testing your basic root finding implementations
function basic_solver_with_tests_template()
    xvals = linspace(-50,50,201);
    [yvals,~] = test_func01(xvals);

    hold on
    axis([-15,40,-50,80]);
    plot(xvals,yvals,'r','linewidth',2);
    plot(xvals,0*xvals,'k--','linewidth',1);
    xlabel('x'); ylabel('y'); title('Test function 1');

    % setting key values
    ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
    dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
    dxmax = 1e14;
    max_iter = 1000;

    % %Newton's method example test
    % x0_guess = 2;
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5); 
    % x_sol = newton_solver(@test_func01,x0_guess, dxtol, ftol, max_iter, dxmax);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
    

    % % Secant method example test
    % x0_guess = -5;
    % x1_guess = 2;
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % plot(x1_guess,test_func01(x1_guess),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = secant_solver(@test_func01,x0_guess,x1_guess, dxtol, ftol, max_iter, dxmax);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);


    % % Bisection method example test
    % x_left = -5;
    % x_right = 2;
    % plot(x_left,test_func01(x_left),'bo','markerfacecolor','b','markersize',5);
    % plot(x_right,test_func01(x_right),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = bisection_solver(@test_func01,x_left,x_right, dxtol, ftol, max_iter);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);

end


%Definition of the test function and its derivative (as a single function):
%This definition uses the function keyword
%when passing this function as an argument to a solver,
%you'll need to use the handle operator
%ex. solver(@test_func01,x_guess)
function [fval,dfdx] = test_func01(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end


% fun: the function we are computing the root of
% x_left: left guess
% x_right: right guess
% note that f(x_left) and f(x_right) should have different signs
% dxtol: termination threshold (stop when interval x_right-x_left < dxtol)
% ftol: termination threshold (stop when abs(f(x_guess))<ftol
%OUTPUTS
% x: estimate for root of fun
function x = bisection_solver(fun,x_left,x_right, dxtol, ftol, max_iter)
    % bisection safeguard - check that there is a 0 crossing
    if (fun(x_left) < 0 && fun(x_right) > 0) || (fun(x_left) > 0 && fun(x_right) < 0)
        for i = 1:max_iter
            % find the middle x 
            x_m = (x_right + x_left)/2;
            % evaluate the function at left, right, and middle x vals
            f_x_m = fun(x_m);
            f_x_L = fun(x_left);
            f_x_R = fun(x_right);
            % if statements -> determine direction of new bracket
            if abs(f_x_m) < ftol %if x_m is root, return root
                x = x_m;
                return
            elseif (f_x_L > 0 && f_x_m < 0) || (f_x_L < 0 && f_x_m > 0)
                x_right = x_m;
            elseif (f_x_R > 0 && f_x_m < 0) || (f_x_R < 0 && f_x_m > 0)
                x_left = x_m;
            end

            % dxtol check
            if abs(x_right - x_left) < dxtol
                x = (x_left + x_right)/2;
                return
            end
        end

        % final midpoint
        x = (x_left + x_right) / 2;
    end
end



%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
%INPUTS:
% fun: the function we are computing the root of
% Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
% (see test_func01 below for example)
% x0: initial guess for Newton's method
% dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% ftol: termination threshold (stop when abs(f(x_{i}))<ftol
% max_iter: maximum iteration limit
% dxmax: threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
% x: estimate for root of fun
% exit_flag: an integer indicating whether or not the solver succeeded
function x = newton_solver(fun,x0,dxtol,ftol, max_iter,dxmax)
    %Initialize the code
    for i = 1:max_iter
        [f, dfdx] = fun(x0);
        if abs(f) < ftol
            x = x0;
            return
        end
        %Pulls the value of the function and its derivative at x = x0
        if (abs(f) == 0)
        %Checks if the function satisfies the ranged condition
            x = x0;
            return
        else
            if abs(dfdx) <= 1e-14
                %Checks if the denominator will be too small
                x = x0;
                return
            end
            x1 = x0 - (f/dfdx);
            if abs(x1 - x0) < dxtol || abs(x1-x0) > dxmax
                x = x0;
                return
            else
                x0 = x1;
            end

            

            %Establishes new value for x0 for next iteration
        end
    end
end


%Root finding function via secant method
%INPUTS:
% fun: the function we are computing the root of
% x0: first guess for secant method
% x1: second guess for secant method
% max_iter: maximum iteration limit
% dxmax: threshold for checking for a divide by zero error:
% terminate when abs(x_{i+1}-x_i) > dxmax, where dxmax is a very large number
%OUTPUTS
% x: estimate for root of fun
function x = secant_solver(fun,x0, x1, dxtol, ftol, max_iter, dxmax)
    for i = 1:max_iter

        % check denominator to not divide by 0
        if abs(fun(x1) - fun(x0)) < 1e-14
            x = x1;
            return
        end

        % calculate the next estimate x
        x_n = x1 - fun(x1) * (x1 - x0) / (fun(x1) - fun(x0));
        
        % evaluate function at new estimate x
        f_x_n = fun(x_n);
        if abs(f_x_n) < ftol
            x = x_n;
            return
        end
        if abs(x_n - x1) < dxtol
            x = x_n;
            return
        end

        % if not, update x0 and x1 (guesses)
        x0 = x1;
        x1 = x_n;
    end

    x = x_n;
    return
end