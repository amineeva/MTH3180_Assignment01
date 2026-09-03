
% compute errors for solver of choice -> update line 11
e_list0 = abs(x_current_list - x_root);
e_list1 = abs(x_next_list - x_root);


%example for how to generate a log-log plot
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Newton''s Method'); % update based on solver


