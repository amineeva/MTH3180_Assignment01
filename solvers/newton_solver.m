function [x, exit_flag] = newton_solver(fun,x0,dxtol,ftol, max_iter,dxmax)
    % exit_flag: success (1), fail (0) -> whether the function finishes
    %Initialize the code
    exit_flag = 0;

    for i = 1:max_iter
        [f, dfdx] = fun(x0);
        %Pulls the value of the function and its derivative at x = x0
        if abs(f) == 0
            %Checks if it is a true root
            x = x0;
            exit_flag = 1;
            return
        elseif (abs(f) < ftol)
            %Ensures the solution isn't too small
            x = x0;
            exit_flag = 1;
            return
        elseif abs(dfdx) <= ftol
            %Checks if the denominator will be too small
            x = x0;
            return
        end
        x1 = x0 - (f/dfdx);
        %Calculates a new x for the next iterations
        if abs(x1 - x0) < dxtol
            %Ensures the calculated step isn't too small
            x = x0;
            exit_flag = 1;
            return
        elseif abs(x1-x0) > dxmax
            %ensures the calculated step isn't too mlarge
            x = x0;
            return

        else
            x0 = x1;
            %Establishes new value for x0 for next iteration
        end
    end
end
