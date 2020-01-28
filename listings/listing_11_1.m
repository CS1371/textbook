% close all the previous figures.  As with clear and clc, we will
% assume that all subsequent plotting examples include this line.
close all
% set a suitable range of x values for all the plots
x = -2*pi:.05:2*pi;
% set the first sub-plot region in the top left position
subplot(3,2,1)
% draw and title the plot
plot(x, sin(x))
title('1: sin(x)'); grid on
% the second sub-plot is at the top right
subplot(3,2,2)
plot(x, cos(x))
title('2: cos(x)'); grid on
% the third sub-plot is below the first plot in the left column
subplot(3,2,3)
plot(x, tan(x))
title('3: tan(x)'); grid on
subplot(3,2,4)
plot(x, x.^2)
title('4: x^2'); grid on
subplot(3,2,5)
plot(x, sqrt(x))
title('5: sqrt(x)'); grid on
subplot(3,2,6)
plot(x, exp(x))
title('6: e^x'); grid on
