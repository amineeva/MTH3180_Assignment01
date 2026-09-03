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