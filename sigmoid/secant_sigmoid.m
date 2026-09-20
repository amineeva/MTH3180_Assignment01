clear;
hold on
ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
dxmax = 1e14;
max_iter = 100;
num_iter = max_iter;

%Create list of guesses
x0_list = linspace(-25, 75,num_iter);
x1_list = linspace(-25, 75,num_iter);

%Set up plot
axis([x_root-50,x_root+50,x_root-50, x_root+50]);
xline(x_root, 'k--')
yline(x_root, 'k--')
% plot(x0_list,x_root,'k--','linewidth',2);
% plot(x_root,x1_list,'k--','linewidth',1);
%plot(x0vals, x1vals)

xlabel('x0'); ylabel('x1'); title('Secant Sigmoid Function');

%Set up lists to be made into matrices later
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

%Added guesses to plot
 h2 = plot(x0_correct, x1_correct,'g.','markersize',5)
 h3 = plot(x0_invalid, x1_invalid, 'r.','markersize',5)
h1 = plot(x_root, x_root, 'bo','markerfacecolor','b','markersize',5);
 legend([h1 h2 h3], {'Root', 'Valid Data Point', 'Invalid Data Point'}, 'Location', 'northeast', 'FontSize', 10)
hold off

%Function for sigmoid equation
function [f_val,dfdx] = test_function03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end
