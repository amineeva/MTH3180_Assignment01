 clear;
hold on
 x_root = fzero(@test_function03, 2)
 xvals = linspace(x_root-50,x_root+50,1000);
 [yvals,~] = test_function03(xvals);
 axis([x_root-50,x_root+50,-10,10]);
 plot(xvals,yvals,'c-','linewidth',2);
 plot(xvals,0*xvals,'k--','linewidth',1);
 xlabel('x'); ylabel('y'); title('FZero Sigmoid Function');
 plot(x_root, test_function03(x_root), 'bo','markerfacecolor','b','markersize',5)

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

 plot(x_correct, test_function03(x_correct),'g.','markersize',5)
 plot(x_invalid, test_function03(x_invalid), 'r.','markersize',5)
 hold off


 %num_iter = 
% 
% x_root = fzero(@test_function03, 2)
% 
% plot(x_root, test_function03(x_root), 'bo','markerfacecolor','b','markersize',5)

%%%%%
% To get the convergence plots, you must first run this file with your
% solver of choice, and then run 'error_computation_plotter.m' with your
% solver of choice.
%%%%%

% method flag
% method_flag = 4; % 1 (newton's), 2 (bisection), 3 (secant), 4 (fzero)
% 
% 
% % setting key values
% ftol = 1e-14; % ftol: termination threshold (stop when abs(f(x_{i}))<ftol
% dxtol = 1e-14; % dxtol: termination threshold (stop when interval abs(x_{i+1}-x_i) < dxtol)
% dxmax = 1e14;
% max_iter = 1000; % number of iterations per trial
% num_iter = 1000; % number of trials we would like to perform
% 
% 
% %Create an instance of the input_recorder
% my_recorder = input_recorder();
% 
% %Use input_recorder to generate a version of the test function
% %that records the input after every iteration
% %Since test_fun is defined using function keyword
% f_record = my_recorder.generate_recorder_fun(@test_function03);
% 
% 
% %list for the initial guesses that we would like
% %to use each trial. These guesses have all been chosen
% %so that each trial will converge to the same root
% %because the root is somewhere between -5 and 5.
% 
% if method_flag == 1 || method_flag == 4 % newton's, fzero
%     x0_list = linspace(-5,5,num_iter); %used for newton's method
% end
% 
% if method_flag == 2 || method_flag == 3 % bisection, secant
%     % bisection
%     x0_list = linspace(-5,0,num_iter); %linspace(-10,0.5,num_iter);
%     x1_list = linspace(0,5,num_iter); %linspace(0.9,10,num_iter);
% end
% 
% %list of estimate at current iteration (x_{n})
% %compiled across all trials
% x_current_list = [];
% %list of estimate at next iteration (x_{n+1})
% %compiled across all trials
% x_next_list = [];
% %keeps track of which iteration (n) in a trial
% %each data point was collected from
% index_list = [];
% 
% % for bisection solver need to track most recently discarded values
% x_discarded_list = [];
% x_next_discarded_list = [];
% 
% % calculate the "true root"
% x_true = fzero(@test_function03, 0);
% 
% 
% %loop through each trial
% for n = 1:num_iter
%     %pull out the left and right guess for the trial
%     x0 = x0_list(n); % needed for newton, bisection, secant
% 
%     if method_flag == 2 || method_flag == 3
%         x1 = x1_list(n); % only needed for bisection, secant
%     end
% 
%     %reset input_list for the next test
%     my_recorder.clear_input_list();
%     %Call your root finder using the recording function:
% 
%     if method_flag == 1
%         % newton solver
%         x_root = newton_solver(f_record,x0, dxtol, ftol, num_iter, dxmax);
%     end
%     if method_flag == 2
%         % bisection solver
%         [x_root, discarded_list] = bisection_solver(f_record, x0, x1, dxtol, ftol, max_iter);
%     end
%     if method_flag == 3
%         % secant
%         [x_root, ef] = secant_solver(f_record, x0, x1, dxtol, ftol, num_iter, dxmax);
%     end
%     if method_flag == 4
%         % secant
%         x_root = fzero(f_record, x0)
%     end
% 
%     %See what input values were used when f_record was called:
%     input_list = my_recorder.get_input_list();
% 
%     %at this point, input_list will be populated with the values that
%     %the solver called at each iteration.
%     %In other words, it is now [x_1,x_2,...x_n-1,x_n]
%     %append the collected data to the compilation
% 
%     if method_flag == 1 || method_flag == 3 || method_flag == 4 % newton, secant
%         x_current_list = [x_current_list,input_list(1:end-1)];
%         x_next_list = [x_next_list,input_list(2:end)];
%         index_list = [index_list,1:length(input_list)-1];
%     end
% 
%     if method_flag == 2 % bisection
%         x_discarded_list = [x_discarded_list, discarded_list(1:end-1)];
%         x_next_discarded_list = [x_next_discarded_list, discarded_list(2:end)];
%         index_list = [index_list, 1:length(discarded_list)-1];
%     end
% 
% end
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
        % check denominator to not divide by 0
        if abs(f1 - f0) < 1e-14
            x = x1;
            exit_flag = 1;
            return
        end
        % calculate the next estimate x
        x_n = x1 - f1 * (x1 - x0) / (f1 - f0);

        % evaluate function at new estimate x
        f_n = fun(x_n);
        if abs(f_n) < ftol
            x = x_n;
            exit_flag = 1;
            return
        end
        if abs(x_n - x1) < dxtol
            x = x_n;
            exit_flag = 1;
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