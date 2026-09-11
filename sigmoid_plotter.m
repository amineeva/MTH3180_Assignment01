%%%%
% Use to plot the sigmoid funcs
%%%%


plot_symbolic_example(x0_success_list, x0_fail_list, x_true)


function plot_symbolic_example(x0_success_list, x0_fail_list, x_true)
    x_vals = linspace(-100,100,500);

    % Sigmoid function
    a = 27.3;
    b = 2;
    c = 8.3;
    d = -3;

    H = exp((x_vals-a)/b);
    f_vals = c*H./(1+H)+d;

    figure;
    plot(x_vals, f_vals, 'LineWidth', 2);
    axis([-45 100 -4 8])
    hold on;

    % Successful points
    plot(x0_success_list, test_function03(x0_success_list),'g.', 'MarkerSize', 5);

    % Failed points
    plot(x0_fail_list, test_function03(x0_fail_list),'r.', 'MarkerSize', 5);

    % plot the root
    plot(x_true, test_function03(x_true), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');

    % y = 0 line
    yline(0, 'k--', 'LineWidth', 1.5);

    grid on;
    xlabel('x');
    ylabel('f(x)');
    title('Sigmoid Function - Newton''s Method');
    legend('f(x)', 'Success', 'Failure', 'Root', 'f(x) = 0', 'Location', 'northwest');

end


function [f_val,dfdx] = test_function03(x)
    a = 27.3; b = 2; c = 8.3; d = -3;
    H = exp((x-a)/b);
    dH = H/b;
    L = 1+H;
    dL = dH;
    f_val = c*H./L+d;
    dfdx = c*(L.*dH-H.*dL)./(L.^2);
end