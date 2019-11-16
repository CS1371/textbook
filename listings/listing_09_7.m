% Finding arm position
function main
    global r1
    r1 = 4
    global r2
    r2 = 3
    global alpha
    alpha = pi/6 % 30 deg
    beta = linspace(-pi, pi, 19);
    pf = fab(beta);
    zeros = find(pf(1:end-1) .* pf(2:end) <= 0)
    disp('zeros occur just after')
    beta(zeros)
    %
    zero = findZeroAB([beta(zeros(1)) ...
        beta(zeros(1)+1)])
end
function res = fab(beta)
    % f(beta) = r1 (cos(alpha) + sin(alpha) - 1)
    %	+ r2 (cos(beta) + sin(beta) - 1)
    global r1
    global r2
    global alpha
    res = r1 * (cos(alpha) + sin(alpha) - 1) ...
        + r2 * (cos(beta) + sin(beta) - 1);
end
function pt = findZeroAB(x)
    % x is a lower-upper pair guaranteed to have
    % y values of opposite sign
    y = fab(x);
    if abs(x(1)-x(2)) < .001
        pt = [x(1) y(1)];
    else
        mx = sum(x)/2;
        my = fab(mx);
        if my*y(1) < 0
            pt = findZeroAB([x(1) mx]);
        else
            pt = findZeroAB([mx x(2)]);
        end
    end
end
