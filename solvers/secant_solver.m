function x = secant_solver(fun,x0,x1,dxtol,ftol,max_iter,dxmax)
    f0 = fun(x0);
    f1 = fun(x1);
    for i = 1:max_iter
        % check denominator to not divide by 0
        if abs(f1 - f0) < 1e-14
            x = x1;
            return
        end
        % calculate the next estimate x
        x_n = x1 - f1 * (x1 - x0) / (f1 - f0);

        % evaluate function at new estimate x
        f_n = fun(x_n);
        if abs(f_n) < ftol
            x = x_n;
            return
        end
        if abs(x_n - x1) < dxtol
            x = x_n;
            return
        end

        % if not, update x0 and x1 (guesses) and update the functions
        x0 = x1;
        f0 = f1;

        x1 = x_n;
        f1 = f_n;
    end

    x = x_n;
end
