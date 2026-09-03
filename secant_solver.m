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