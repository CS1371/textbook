% Simple 3-D line plots
function main
    % Each plot has the same set of x values
    x=0:0.1:3.*pi;
    % The y values for the first plot are all 0.
    y1=zeros(size(x));
    z1=sin(x);
    %  The second and third plots are sin(x) at different frequencies
    z2=sin(2.*x);
    z3=sin(3.*x);
    % The y values of the second and third plots are all 0.5 and 1, respectively.
    y3=ones(size(x));
    y2=y3./2;
    plot3(x,y1,z1, 'r',x,y2,z2, 'b',x,y3,z3, 'g')
    grid on
    xlabel('x-axis'), ylabel('y-axis'), zlabel('z-axis')
end
