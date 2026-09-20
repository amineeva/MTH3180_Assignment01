function egganimation()
    mypath1 = 'C:\Users\ccirone\Downloads';
    fname='square_animation.avi';
    input_fname = [mypath1, fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    open(writerObj); %must call open before writing any frames

    fig = figure();
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    tr = linspace(1,20,1000);

    trajectory = @egg_trajectory01;

    xg = 34;
    yw = 0;

    [tg, tw] = collision_func(trajectory, egg_params, yw, xg);

    %specify the position and orientation of the egg
    x0 = 5; y0 = 5;

    %create the plot
    hold on; axis equal; axis square
    axis([0,35,0,35])
    xlabel('X Value'); ylabel('Y Value')
    title('Egg Trajectory Animation')

    xline(xg, 'k-') %Ground
    yline(yw, 'k-') %Wall

    egg = plot(0,0, 'm')

    sr = linspace(0,1,400)

    for n = 1:length(tr)
        if tr(n) >= tg %if it hits the ground first
            disp('The egg has cracked!')
            return;
        end
        if tr(n) >= tw %if it hits the wall first
            disp('The egg has cracked!')
            return;
        end

        [x0, y0, theta] = trajectory(tr(n));

        %Find V and G values in that instance
        [V,G] = egg_func(sr, x0, y0, theta, egg_params);

        %Create the visuals the frame
        set(egg, 'xdata', V(1,:), 'ydata', V(2,:));
        drawnow;
        frame = getframe(fig);
        writeVideo(writerObj,frame);

    end
    close(writerObj)
end
