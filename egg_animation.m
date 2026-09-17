function egganimation()
    mypath1 = 'C:\Users\taylorott\Dropbox (Personal)\OrionTeachingMaterials\';
    mypath2 = 'AppliedMathForEngineers\Modules\Strandbeest\graphics\';
    fname='square_animation.avi';
    input_fname = [mypath1,mypath2,fname];

    %create a videowriter, which will write frames to the animation file
    writerObj = VideoWriter(input_fname);
    open(writerObj); %must call open before writing any frames

    fig = figure();
    egg_params = struct();
    egg_params.a = 3; egg_params.b = 2; egg_params.c = .15;

    tr = linspace(1,20,1000);

    trajectory = @egg_trajectory01;

    xg = 68;
    yw = 0;

    [tg, tw] = collision_func(trajectory, egg_params, yw, xg);

    %specify the position and orientation of the egg
    x0 = 5; y0 = 5;

    %set up the axis
    hold on; axis equal; axis square
    axis([0,70,0,70])
    xlabel('X Value'); ylabel('Y Value')
    title('Egg Trajectory Animation')

    xline(xwall, 'k-')
    yline(yg, 'k-')

    plot(0,0, 'r')

    sr = [0,1, 400]

    for n = 1:length(tr)
        if tr(n) >= tg
            disp('The egg has cracked!')
            return;
        end
        if tr(n) >= tw
            disp('The egg has cracked!')
            return;
        end

        [x0, y0, theta] = trajectory(tr(n));

        [V,G] = egg_func(sr, x0, y0, theta, egg_params);
        plot(x0,y0,'ro','markerfacecolor','r');
        plot(V(1,:),V(2,:),'k');

        frame = getframe(fig);
        writeVideo(writerObj,current_frame);

    end
    close(writerObj)
end

function [x0,y0,theta] = egg_trajectory01(t)
    x0 = 7*t + 8;
    y0 = -6*t.^2 + 20*t + 6;
    theta = 5*t;
end