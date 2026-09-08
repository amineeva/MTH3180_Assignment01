%%%%%
% To get the convergence plots, you must first run this file with your
% solver of choice, and then run 'error_computation_plotter.m' with your
% solver of choice.
%%%%%

% method flag
method_flag = 3; % 1 (newton's), 2 (bisection), 3 (secant), 4 (fzero)


% setting key values
ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
dxmax = 1e14;
max_iter = 1000; % number of iterations per trial
num_iter = 1000; % number of trials we would like to perform


%Create an instance of the input_recorder
my_recorder = input_recorder();

%Use input_recorder to generate a version of the test function
%that records the input after every iteration
%Since test_fun is defined using function keyword
f_record = my_recorder.generate_recorder_fun(@example_function);


%list for the initial guesses that we would like
%to use each trial. These guesses have all been chosen
%so that each trial will converge to the same root
%because the root is somewhere between -5 and 5.

if method_flag == 1 % newton's
    x0_list = linspace(-5,5,num_iter); %used for newton's method
end

if method_flag == 2 || method_flag == 3 % bisection, secant
    % bisection
    x0_list = linspace(-5,0,num_iter); %linspace(-10,0.5,num_iter);
    x1_list = linspace(0,5,num_iter); %linspace(0.9,10,num_iter);
end

%list of estimate at current iteration (x_{n})
%compiled across all trials
x_current_list = [];
%list of estimate at next iteration (x_{n+1})
%compiled across all trials
x_next_list = [];
%keeps track of which iteration (n) in a trial
%each data point was collected from
index_list = [];

% for bisection solver need to track most recently discarded values
x_discarded_list = [];
x_next_discarded_list = [];

% calculate the "true root"
x_true = fzero(@example_function, 0);


%loop through each trial
for n = 1:num_iter
    %pull out the left and right guess for the trial
    x0 = x0_list(n); % needed for newton, bisection, secant

    if method_flag == 2 || method_flag == 3
        x1 = x1_list(n); % only needed for bisection, secant
    end

    %reset input_list for the next test
    my_recorder.clear_input_list();
    %Call your root finder using the recording function:
    
    if method_flag == 1
        % newton solver
        x_root = newton_solver(f_record,x0, dxtol, ftol, num_iter, dxmax);
    end
    if method_flag == 2
        % bisection solver
        [x_root, discarded_list] = bisection_solver(f_record, x0, x1, dxtol, ftol, max_iter);
    end
    if method_flag == 3
        % secant
        x_root = secant_solver(f_record, x0, x1, dxtol, ftol, num_iter, dxmax);
    end

    %See what input values were used when f_record was called:
    input_list = my_recorder.get_input_list();

    %at this point, input_list will be populated with the values that
    %the solver called at each iteration.
    %In other words, it is now [x_1,x_2,...x_n-1,x_n]
    %append the collected data to the compilation

    if method_flag == 1 || method_flag == 3 % newton, secant
        x_current_list = [x_current_list,input_list(1:end-1)];
        x_next_list = [x_next_list,input_list(2:end)];
        index_list = [index_list,1:length(input_list)-1];
    end

    if method_flag == 2 % bisection
        x_discarded_list = [x_discarded_list, discarded_list(1:end-1)];
        x_next_discarded_list = [x_next_discarded_list, discarded_list(2:end)];
        index_list = [index_list, 1:length(discarded_list)-1];
    end

end
%At this point, x_current_list corresponds to many many
%measurements of x_{n} across many trials
%and x_next_list corresponds to many many measurements of
%the corresponding value of x_{n+1} across many trials
%this is the data the you want to clean and analaze




% setting the function
function [fval,dfdx] = example_function(x)
    fval = (x.^3)/100 - (x.^2)/8 + 2*x + 6*sin(x/2+6) -.7 - exp(x/6);
    dfdx = 3*(x.^2)/100 - 2*x/8 + 2 +(6/2)*cos(x/2+6) - exp(x/6)/6;
end