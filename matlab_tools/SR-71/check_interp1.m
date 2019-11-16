clear
clc
close all
load('gotcha.mat')
plot(widex, widey)
wp = interp1(widex, widey, x)
hold on
plot([x x], [0 wp], 'k')
d = widex(1:end-1) - widex(2:end);
at = find(d > 0)
widex(at-2:at+2)

