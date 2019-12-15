clear
clc
close all

x = linspace(-8, 10, 300);
y = f(x);
plot(x, y);
title('Y = f(X)');
xlabel('X');
ylabel('Y');
grid on
hold on
plot([-8 10], [0 0], 'k')

px = linspace(-6.3, 8.4, 19);
py = f(px);
plot(px, py, 'r+')
zeros = find(py(1:end-1) .* py(2:end) <= 0);
plot(px(zeros), py(zeros), 'go')