% listing_03_2
% test the cylinder function with multiple results
function main
    [a v] = my_cylinder(1, 6)
end

function [area, volume] = my_cylinder(height, radius)
    % function to compute the area and volume of a cylinder
    % usage: [area, volume]=cylinder(height, radius)
    base = pi .* radius.^2;
    volume = base .* height;
    area = 2 * pi * radius .* height + 2 * base;
end
