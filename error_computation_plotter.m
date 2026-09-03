
% compute errors for solver of choice -> update line 29, 35
e_list0 = abs(x_current_list - x_root);
e_list1 = abs(x_next_list - x_root);


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


%log-log for raw error data
fig1 = figure(1);
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Raw Error Data: Newton''s Method'); % update based on solver

%log-log for filtered error data (overlayed on raw error data
fig2 = figure(2)
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
hold on;
loglog(x_regression,y_regression,'b--<','markerfacecolor','r','markersize',1);
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Filtered Error Data: Newton''s Method'); % update based on solver
hold off;