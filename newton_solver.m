function x = newton_solver(fun,x0,dxtol,ftol, max_iter,dxmax)
    %Initialize the code
    for i = 1:max_iter
        [f, dfdx] = fun(x0);
        %Pulls the value of the function and its derivative at x = x0
        if abs(f) < ftol
            %Ensures the function isn't too small
            x = x0;
            return
        elseif (abs(f) == 0)
            %Checks if the function satisfies the ranged condition
            x = x0;
            return
        elseif abs(dfdx) <= ftol
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
    end

            

            %Establishes new value for x0 for next iteration
        end
    end
end
