% compute the volume and area of a flange
function main
    h = 1; % thickness - all measurements in inches
    R = 5; % outer radius
    cr = 2; % center hole
    hr = 0.25; % small holes
    [A, V] = my_cylinder(h, R); % whole disk
    [cA, cV, cT] = my_cylinder(h, cr); % center hole
    [hA, hV, hT] = my_cylinder(h, hr); % small holes
    Volume = V - cV - 8 * hV
    Area = A + cA + 8 * hA;
    % but we need to subtract tops and bottoms
    Area = Area - 4 * cT - 4 * 8 * hT
end

function [area, volume, top] = my_cylinder(height, radius)
    % function to compute the area and volume of a cylinder
    % usage: [area, volume]=cylinder(height, radius)
    top = pi .* radius.^2;
    volume = top .* height;
    area = 2 * pi * radius .* height + 2 * top;
end
