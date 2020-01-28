% Simple 2-D plots
function main
% set the range of X values
    x = linspace(-1.5, 1.5, 30);
    % each character is the color specification for
    % one of the lines
    clr = 'rgbk';
    % make 4 plots overlaid on the same figure
    for pwr = 1:4
        plot(x, x.^pwr, clr(pwr))
        hold on
    end
    % label the axes
    xlabel('x')
    ylabel('x^N')
    % add a title
    title('powers of x')
    % show the grid
    grid on
    % Apply a legend in the bottom right corner of the plot
    legend({'N=1', 'N=2', 'N=3', 'N=4'}, ...
        'Location','SouthEast')
end
