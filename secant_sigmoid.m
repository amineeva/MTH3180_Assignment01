clear;
hold on
ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
dxmax = 1e14;
max_iter = 100;
num_iter = max_iter;

x_root = fzero(@test_function03, 2);

x0_list = linspace(-25, 75,num_iter);
x1_list = linspace(-25, 75,num_iter);
[x0vals, x1vals] = meshgrid(x0_list, x1_list);
axis([x_root-50,x_root+50,x_root-50, x_root+50]);

xline(x_root, 'k--')
yline(x_root, 'k--')
% plot(x0_list,x_root,'k--','linewidth',2);
% plot(x_root,x1_list,'k--','linewidth',1);
%plot(x0vals, x1vals)

xlabel('x0'); ylabel('x1'); title('Secant Sigmoid Function');

 x0_correct = [];
 x1_correct = [];
x0_invalid = [];
x1_invalid = [];
 for n = 1:length(x0_list)
     for i = 1:length(x1_list)
      [xrg, exit_flag] = secant_solver(@test_function03, x0_list(n), x1_list(i), dxtol, ftol, num_iter, dxmax);
      if exit_flag == 1
          x0_correct = [x0_correct, x0_list(n)];
          x1_correct = [x1_correct, x1_list(i)];
      else
          x0_invalid = [x0_invalid, x0_list(n)];
          x1_invalid = [x1_invalid, x1_list(i)];
      end
     end
 end

 % [X_correct, Y_correct] = meshgrid(x0_correct, x1_correct);
 % [X_invalid, Y_invalid] = meshgrid(x0_invalid, x1_invalid);

 h2 = plot(x0_correct, x1_correct,'g.','markersize',5)
 h3 = plot(x0_invalid, x1_invalid, 'r.','markersize',5)
h1 = plot(x_root, x_root, 'bo','markerfacecolor','b','markersize',5);
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
% function [x, exit_flag] = secant_solver(fun,x0,x1,dxtol,ftol,max_iter,dxmax)
%     exit_flag = 0;
%     f0 = fun(x0);
%     f1 = fun(x1);
%     for i = 1:max_iter
%         % check denominator to not divide by 0
%         if abs(f1 - f0) < 1e-14
%             x = x1;
%             exit_flag = 1;
%             return
%         end
%         % calculate the next estimate x
%         x_n = x1 - f1 * (x1 - x0) / (f1 - f0);
% 
%         % evaluate function at new estimate x
%         f_n = fun(x_n);
%         if abs(f_n) < ftol
%             x = x_n;
%             exit_flag = 1;
%             return
%         end
%         if abs(x_n - x1) < dxtol
%             x = x_n;
%             exit_flag = 1;
%             return
%         end
% 
%         % if not, update x0 and x1 (guesses) and update the functions
%         x0 = x1;
%         f0 = f1;
% 
%         x1 = x_n;
%         f1 = f_n;
%     end
% 
%     x = x_n;
% end