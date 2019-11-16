% listing_03_1
% simple cylinder function
clear; clc
    v = my_cylinder(1, 6)
    
function volume = my_cylinder(height, radius)
    % function to compute the volume of a cylinder
    % volume = cylinder(height, radius)
    base = pi * radius^2;
    volume = base * height;
end
