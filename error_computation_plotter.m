% currently just for newton's

% compute errors for newton's solver
e_list0 = abs(x_current_list - x_root);
e_list1 = abs(x_next_list - x_root);



%example for how to generate a log-log plot
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);