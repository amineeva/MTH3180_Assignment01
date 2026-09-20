function [x, exit_flag] = secant_solver(fun,x0,x1,dxtol,ftol,max_iter,dxmax)

    exit_flag = 0;

    f0 = fun(x0);
    f1 = fun(x1);

    for i = 1:max_iter

        % Check denominator
        if abs(f1 - f0) < eps * max([1, abs(f1), abs(f0)])
            x = x1;
            return
        end

        % Calculate next estimate
        x_n = x1 - f1 * (x1 - x0) / (f1 - f0);

        % Check for numerical failure
        if ~isfinite(x_n)
            x = x_n;
            return
        end

        % Check maximum step
        if abs(x_n - x1) > dxmax
            x = x_n;
            return
        end

        % Evaluate function
        f_n = fun(x_n);

        % Check function convergence
        if abs(f_n) < ftol
            x = x_n;
            exit_flag = 1;
            return
        end

        % Check x convergence
        if abs(x_n - x1) < dxtol
            x = x_n;
            exit_flag = 1;
            return
        end

        % Update
        x0 = x1;
        f0 = f1;

        x1 = x_n;
        f1 = f_n;
    end

    x = x_n;
end
