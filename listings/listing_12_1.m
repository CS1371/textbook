% Script to rotate a line
function main
    pts = [3, 10
           1, 3];
    plot(pts(1,:), pts(2,:))
    axis ([0 10 0 10]), axis equal
    hold on
    for angle = 0.05:0.05:1
        A = [ cos(angle), -sin(angle); sin(angle), cos(angle) ];
        pr = A * pts;
        plot(pr(1,:), pr(2,:))
    end
end
