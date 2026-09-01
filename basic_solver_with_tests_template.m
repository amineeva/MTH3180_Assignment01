%template for testing your basic root finding implementations
function basic_solver_with_tests_template()
    xvals = linspace(-50,50,201);
    [yvals,~] = test_func01(xvals);

    hold on
    axis([-15,40,-50,80]);
    plot(xvals,yvals,'r','linewidth',2);
    plot(xvals,0*xvals,'k--','linewidth',1);
    xlabel('x'); ylabel('y'); title('Test function 1');

    % %Newton's method example test
    % x0_guess = 2;
    % plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    % 
    % x_sol = newton_solver(@test_func01,x0_guess);
    % plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);
    

    % Secant method example test
    x0_guess = -5;
    x1_guess = 2;
    plot(x0_guess,test_func01(x0_guess),'bo','markerfacecolor','b','markersize',5);
    plot(x1_guess,test_func01(x1_guess),'ko','markerfacecolor','k','markersize',5);

    x_sol = secant_solver(@test_func01,x0_guess,x1_guess);
    plot(x_sol,test_func01(x_sol),'go','markerfacecolor','g','markersize',5);

    
    % % Bisection method example test
    % x_left = -5;
    % x_right = 2;
    % plot(x_left,test_func01(x_left),'bo','markerfacecolor','b','markersize',5);
    % plot(x_right,test_func01(x_right),'ko','markerfacecolor','k','markersize',5);
    % 
    % x_sol = bisection_solver(@test_func01,x_left,x_right);
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
%OUTPUTS
% x: estimate for root of fun
function x = bisection_solver(fun,x_left,x_right)
    f_x_m = 1; % initialize so while loop can start 
    while (f_x_m ~= 0)
        % find the middle x 
        x_m = (x_right + x_left)/2;
        % evaluate the function at left, right, and middle x vals
        f_x_m = fun(x_m);
        f_x_L = fun(x_left);
        f_x_R = fun(x_right);
        % if statements -> determine direction of new bracket
        if f_x_m == 0 %if x_m is root, return root
            x = x_m;
            return
        elseif (f_x_L > 0 && f_x_m < 0) || (f_x_L < 0 && f_x_m > 0)
            x_left = x_left;
            x_right = x_m;
        elseif (f_x_R > 0 && f_x_m < 0) || (f_x_R < 0 && f_x_m > 0)
            x_right = x_right;
            x_left = x_m;
        end
    end

end



%Note that fun(x) should output [f,dfdx], where dfdx is the derivative of f
function x = newton_solver(fun,x0)
    x = x0+1; %this is just dummy code. replace this with your code

end


%Root finding function via secant method
%INPUTS:
% fun: the function we are computing the root of
% x0: first guess for secant method
% x1: second guess for secant method
%OUTPUTS
% x: estimate for root of fun
function x = secant_solver(fun,x0, x1)
    f_x_n = 1; % initialize so while loop can start 
    while (f_x_n ~= 0)
        % calculate the next estimate x
        x_n = x1 - fun(x1) * (x1 - x0) / (fun(x1) - fun(x0));
        
        % evaluate function at new estimate x
        f_x_n = fun(x_n);

        % check if root
        if f_x_n == 0
            x = x_n;
            return
        end

        % if not, update x0 and x1 (guesses)
        x0 = x1;
        x1 = x_n;

        disp(x0)
        disp(x1)
        disp(x_n)
    end
end




