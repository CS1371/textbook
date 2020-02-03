% listing_03_1
% test the my_cylinder function
function main
    v = my_cylinder(1, 6)
end
    
function volume = my_cylinder(height, radius)
    % function to compute the volume of a cylinder
    % volume = cylinder(height, radius)
    base = pi * radius^2;
    volume = base * height;
end
