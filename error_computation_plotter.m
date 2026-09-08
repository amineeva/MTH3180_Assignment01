%%%%%
% To get the convergence plots, you must first run 'input_recorder_step_one.m' with your
% solver of choice, and then run this file with your
% solver of choice.
%%%%%

% % compute errors for solver of choice

if method_flag == 1
    % newton's method
    e_list0 = abs(x_current_list - x_true); %used for newton
    e_list1 = abs(x_next_list - x_true); %used for newton
    method_name = "Newton's";
end

if method_flag == 2
    % bisection
    e_list0 = abs(x_discarded_list - x_true); % used for bisection
    e_list1 = abs(x_next_discarded_list - x_true);
    method_name = "Bisection";
end

if method_flag == 3
    % secant
    e_list0 = abs(x_current_list - x_true);
    e_list1 = abs(x_next_list - x_true);
    method_name = "Secant's";
end



% Filter the collected error data
%currently have e_list0, e_list1, index_list data points to be used in the regression
x_regression = []; % e_n
y_regression = []; % e_{n+1}
filter_list = [1e-15, 1e-2, 1e-14, 1e-2, 2];
%iterate through the collected data
for n=1:length(index_list)
    %if the error is not too big or too small and it was enough iterations into the trial...
    if e_list0(n)>filter_list(1) && e_list0(n)<filter_list(2) && ...
        e_list1(n)>filter_list(3) && e_list1(n)<filter_list(4) && ...
        index_list(n)>filter_list(5)
        %then add it to the set of points for regression
        x_regression(end+1) = e_list0(n);
        y_regression(end+1) = e_list1(n);
    end
end

[p, k] = generate_error_fit(x_regression,y_regression);
%generate x data on a logarithmic range
fit_line_x = logspace(log10(min(x_regression)), ...
                      log10(max(x_regression)),200);
%compute the corresponding y values
fit_line_y = k*fit_line_x.^p;

%%%% Plotting %%%%
%log-log for raw error data
fig1 = figure(1);
h1 = loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Raw Error Data: ' + method_name + ' Method'); % update based on solver
legend([h1], {'All data'}, 'Location', 'northwest', 'FontSize', 10)
hold off;

%log-log for filtered error data (overlayed on raw error data
fig2 = figure(2);
h1 = loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
hold on;
h2 = loglog(x_regression,y_regression,'b.','markersize',1);
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Filtered Error Data: ' + method_name + ' Method'); % update based on solver
legend([h1 h2], {'All data', 'Filtered data'}, 'Location', 'northwest', 'FontSize', 10)
hold off;

%log-log for error data with fit (overlayed on raw error data and filtered
%data)
fig3 = figure(3);
h1 = loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
hold on;
h2 = loglog(x_regression,y_regression,'b.','markersize',1);
h3 = loglog(fit_line_x,fit_line_y,'k-','linewidth',2);
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Error Data with Fit: ' + method_name + ' Method'); % update based on solver
legend([h1 h2 h3], {'All data', 'Filtered data', 'Fit'}, 'Location', 'northwest', 'FontSize', 10)
subtitle(sprintf('Fit: e_{n+1} = %.4e e_n^{%.4f} | k = %.4e, p = %.4f', k, p, k, p), ...
    'FontSize', 10);
hold off;



%%% function %%%
%example for how to compute the fit line data points to be used in the regression
%x_regression -> e_n
%y_regression -> e_{n+1}
%p and k are the output coefficients
function [p,k] = generate_error_fit(x_regression,y_regression)
    %generate Y, X1, and X2
    Y = log(y_regression)';
    X1 = log(x_regression)';
    X2 = ones(length(X1),1);
    %run the regression
    coeff_vec = regress(Y,[X1,X2]);
    %pull out the coefficients from the fit
    p = coeff_vec(1);
    k = exp(coeff_vec(2));
end