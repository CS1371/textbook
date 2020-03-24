% Simple surface plot
function main
% define the x and y vectors
    x=-3:3; 
    y =-3:3;
    % produce the x and y values at each intersection
    % as a 7 x 7 array
    % as usual, the variable names are optional.
    % the author tends to use the double letter values
    % to remind us that these are 2-D arrays
    [xx,yy]=meshgrid(x,y);
    % compute the z values at each x-y intersection
    zz=xx.^2 + yy.^2;
    % plot the data with colored lines and white facets
    mesh(xx,yy,zz)
    axis tight
    title('z = x^2 + y^2')
    xlabel('x'),ylabel('y'),zlabel('z')
    view(-30, 30)
end
