% Recursive Root Finding
function main
    px = linspace(-7, 9, 100);
    plot(px, f(px))
    hold on
    grid on
    px = linspace(-6.3, 8.4, 19);
    py = f(px);
    disp('zeros occur just after')
    zeros = find(py(1:end-1) .* py(2:end) <= 0)
    for zndx = 1:length(zeros)
        root = findZero([px(zeros(zndx)) px(zeros(zndx)+1)]);
        plot(root, f(root), 'ro')
        grid on
    end
end
function pt = findZero(x)
    % x is a lower-upper pair guaranteed to have
    % y values of opposite sign
    % return the x coordinate of the root
    if abs(x(1)-x(2)) < .001
        pt = x(1);
    else
        mx = sum(x)/2;
        my = f(mx);
        if my*f(x(1)) <= 0
            pt = findZero([x(1) mx]);
        else
            pt = findZero([mx x(2)]);
        end
    end
end
function res = f(x)
    res = polyval([0.0333, -0.3, -1.3333, 16, 0, -187.2, 172.9],x);
end
