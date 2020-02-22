% Differentiating a function
function main
    % Establish and plot f(x)
    x = -7:0.1:9;
    f = polyval([0.0333,-0.3,-1.3333,16,0,-187.2,0], x);
    plot(x, f)
    grid on, hold on
    
    % The difference expression returns a vector one shorter than the
    % original
    df = diff(f)./diff(x);
    
    % Plot forward, backward, and central differences
    plot(x(2:end), df, 'g')
    plot(x(1:end-1), df, 'r')
    xm = (x(2:end)+x(2:end)) / 2;
    plot(xm, df, 'c')
    grid on
    legend({'f(x)', 'forward', 'backward', 'central'})
end
