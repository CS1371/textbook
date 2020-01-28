% Parametric plots
function main
%   The particular transformation we use here requires a circle 
%   with a radius, r, slightly greater than 1 offset by a small 
%   distance, g, from the x-axis, passing through the point (?1, 0).
%   We need theta from - to 2pi inclusive to form a complete circle.
    th = linspace(0, 2*pi, 40);
    r = 1.1; g = .1;
    % compute the center of the circle passing through the point (?1, 0)
    cx = sqrt(r^2-g^2) - 1; 
    cy = g;
    % A standard polar-to-Cartesian coordinate transformation 
    % computing the coordinates of the circle
    x = r*cos(th) + cx;
    y = r*sin(th) + cy;
    plot( x, y, 'r' )
    axis equal
    grid on, hold on
    % The Joukowski transformation is easiest when expressed in 
    % complex terms: if z is the path around the required circle, 
    % w = z + 1/z traces a very credible looking airfoil shape.
    z = complex(x, y);
    w = z + 1./z;
    plot( real(w), imag(w), 'k' );
end
