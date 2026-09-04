% setting key values
ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
dxmax = 1e14;
max_iter = 1000;


%Create an instance of the input_recorder
my_recorder = input_recorder();

%Use input_recorder to generate a version of the test function
%that records the input after every iteration
%Since test_fun is defined using function keyword
f_record = my_recorder.generate_recorder_fun(@example_function);

%number of trials we would like to perform
num_iter = max_iter;


%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
%because the root is somewhere between -5 and 5.
x0_list = linspace(-5,0,num_iter);
x1_list = linspace(0,5,num_iter);


%list of estimate at current iteration (x_{n})
%compiled across all trials
x_current_list = [];
%list of estimate at next iteration (x_{n+1})
%compiled across all trials
x_next_list = [];
%keeps track of which iteration (n) in a trial
%each data point was collected from
index_list = [];


%loop through each trial
for n = 1:num_iter
    %pull out the left and right guess for the trial
    x0 = x0_list(n);
    x1 = x1_list(n);
    %reset input_list for the next test
    my_recorder.clear_input_list();
    %Call your root finder using the recording function:
    
    x_root = secant_solver(f_record,x0,x1,dxtol, ftol, num_iter, dxmax);
    %See what input values were used when f_record was called:
    input_list = my_recorder.get_input_list();
    %at this point, input_list will be populated with the values that
    %the solver called at each iteration.
    %In other words, it is now [x_1,x_2,...x_n-1,x_n]
    %append the collected data to the compilation
    x_current_list = [x_current_list,input_list(1:end-1)];
    x_next_list = [x_next_list,input_list(2:end)];
    index_list = [index_list,1:length(input_list)-1];
end
%At this point, x_current_list corresponds to many many
%measurements of x_{n} across many trials
%and x_next_list corresponds to many many measurements of
%the corresponding value of x_{n+1} across many trials
%this is the data the you want to clean and analaze

% compute errors for solver of choice -> update line 39, 49, 62
e_list0 = abs(x_current_list - x_root);
e_list1 = abs(x_next_list - x_root);
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);

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
fit_line_x = 10.^[-16:.01:1];
%compute the corresponding y values
fit_line_y = k*fit_line_x.^p;

%%%% Plotting %%%%


%log-log for raw error data
fig1 = figure(1);
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Raw Error Data: Secant Method'); % update based on solver

%log-log for filtered error data (overlayed on raw error data
fig2 = figure(2);
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
hold on;
loglog(x_regression,y_regression,'b--<','markerfacecolor','r','markersize',1);
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Filtered Error Data: Secant Method'); % update based on solver
hold off;

%log-log for error data with fit (overlayed on raw error data and filtered
%data)
fig3 = figure(3);
loglog(e_list0,e_list1,'ro','markerfacecolor','r','markersize',1);
hold on;
loglog(x_regression,y_regression,'b--<','markerfacecolor','r','markersize',1);
loglog(fit_line_x,fit_line_y,'k-','linewidth',2)
axis([1e-18 1e5 1e-18 1e5])
xlabel('$\epsilon_{n} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
ylabel('$\epsilon_{n+1} (-)$', 'Interpreter', 'latex', 'FontSize', 14)
title('Error Data with Fit: Secant Method'); % update based on solver
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

% setting the function
function [fval,dfdx] = example_function(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end

function x = secant_solver(fun,x0,x1,dxtol,ftol,max_iter,dxmax)
    f0 = fun(x0);
    f1 = fun(x1);
    for i = 1:max_iter
        % check denominator to not divide by 0
        if abs(f1 - f0) < 1e-14
            x = x1;
            return
        end
        % calculate the next estimate x
        x_n = x1 - f1 * (x1 - x0) / (f1 - f0);

        % evaluate function at new estimate x
        f_n = fun(x_n);
        if abs(f_n) < ftol
            x = x_n;
            return
        end
        if abs(x_n - x1) < dxtol
            x = x_n;
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