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
