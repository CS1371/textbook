% Simulating stars
function main
    pause(1)
    figure
    nst = 20; th = 0;
    for ndx = 1:nst
        pos(ndx,:) = rand(1,2)*10;
        scale(ndx) = rand(1,1) * .9 + .1;
        rate(ndx) = rand(1,1) * 3 + 1;
    end
    for frame = 1:20
        for str = 1:nst
            star(pos(str,:), ...	% location
                scale(str), ... % scale
                th, ...	% basic angle
                rate(str))	% angle multiplier
        end
        colormap autumn
        axis equal; axis([-.5 10.5 -.5 10.5])
        axis off; hold off
        th = mod(th + .1, 20*pi);
        pause(0.1)
    end
end
function star(pt, sc, v, th)
    % draw a star at pt(1), pt(2),
    % scaled with sc, at angle v*th
    triangle(1, v*th, pt, sc)
    hold on
    triangle(-1, v*th, pt, sc)
end
function triangle( up, th, pt, sc )
    pts = [-.5	.5	0	-.5;	% x values
        -.289 -.289 .577 -.289]; % y values
    % rotation matrix
    A = sc * [cos(th), -sin(th); sin(th), cos(th)];
    thePts = A * pts;
    fill( thePts(1,:) + pt(1), ...
        up*thePts(2,:) + pt(2), 1);
end
