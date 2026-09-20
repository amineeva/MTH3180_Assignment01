clear;
hold on
x_root = fzero(@test_function03, 2)
xvals = linspace(x_root-50,x_root+50,1000);
[yvals,~] = test_function03(xvals);
axis([x_root-50,x_root+50,-10,10]);
plot(xvals,yvals,'c-','linewidth',2);
plot(xvals,0*xvals,'k--','linewidth',1);
xlabel('x'); ylabel('y'); title('FZero Sigmoid Function');
 x0_list = [xvals];
 x_correct = [];
 x_invalid = [];

 for n = 1:1000
     xrg = fzero(@test_function03, x0_list(n));
     if xrg == x_root
         x_correct = [x_correct, x0_list(n)];
     else
         x_invalid = [x_invalid, x0_list(n)];
     end
 end

 h2 = plot(x_correct, test_function03(x_correct),'g.','markersize',5)
 h3 = plot(x_invalid, test_function03(x_invalid), 'r.','markersize',5)
 h1 = plot(x_root, test_function03(x_root), 'bo','markerfacecolor','b','markersize',5)

 legend([h1 h2 h3], {'Root', 'Valid Data Point', 'Invalid Data Point'}, 'Location', 'northeast', 'FontSize', 10)
 hold off

function [f_val,dfdx] = test_function03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end

function [x, exit_flag] = secant_solver(fun,x0,x1,dxtol,ftol,max_iter,dxmax)
    exit_flag = 0;
    f0 = fun(x0);
    f1 = fun(x1);
    for i = 1:max_iter
        % check denominator to not divide by 0
        if abs(f1 - f0) < 1e-14
            x = x1;
            exit_flag = 1;
            return
        end
        % calculate the next estimate x
        x_n = x1 - f1 * (x1 - x0) / (f1 - f0);

        % evaluate function at new estimate x
        f_n = fun(x_n);
        if abs(f_n) < ftol
            x = x_n;
            exit_flag = 1;
            return
        end
        if abs(x_n - x1) < dxtol
            x = x_n;
            exit_flag = 1;
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
