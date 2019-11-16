% Differentiating a function
function main
    pause(1)
    figure
    x = -7:0.1:9;
    f = polyval([0.0333,-0.3,-1.3333,16,0,-187.2,0], x);
    plot(x, f)
    grid on, hold on
    df = diff(f)./diff(x);
    plot(x(2:end), df, 'g')
    plot(x(1:end-1), df, 'r')
    xm = (x(2:end)+x(2:end)) / 2;
    plot(xm, df, 'c')
    grid on
    legend({'f(x)', 'forward', 'backward', 'central'})
end
