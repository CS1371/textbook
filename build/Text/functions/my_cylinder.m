% Listing_05_3  cylinder function with multiple results
function [area, volume] = my_cylinder(height, radius)
    % function to compute the area and volume of a cylinder
    % usage: [area, volume]=cylinder(height, radius)
    base = pi .* radius.^2;
    volume = base .* height;
    area = 2 * pi * radius .* height + 2 * base;
end
