% Simple solid cube
function main
% Basic geometry of the plaid
% 5 columns because we need to close the squares
% The first row of xx, yy and zz defines the point P.
% the last row of xx, yy and zz defines the point Q
% the second and third rows are the top and bottom
% of the cube itself.
    xx = [  0  0  0  0  0  % P-P-P-P-P
           -1 -1  1  1 -1  % A-B-C-D-A
           -1 -1  1  1 -1  % E-F-G-H-E
            0  0  0  0  0] % Q-Q-Q-Q-Q
    yy = [  0  0  0  0  0  % P-P-P-P-P
            1 -1 -1  1  1  % A-B-C-D-A
            1 -1 -1  1  1  % E-F-G-H-E
            0  0  0  0  0] % Q-Q-Q-Q-Q
    zz = [  1  1  1  1  1  % P-P-P-P-P
            1  1  1  1  1  % A-B-C-D-A
           -1 -1 -1 -1 -1  % E-F-G-H-E
           -1 -1 -1 -1 -1] % Q-Q-Q-Q-Q
% these commands define where the letters A - G
%     and P will be drawn.
    A = [xx(2,1) yy(2,1) zz(2,1)];
    B = [xx(2,2) yy(2,2) zz(2,2)];
    C = [xx(2,3) yy(2,3) zz(2,3)];
    D = [xx(2,4) yy(2,4) zz(2,4)];
    E = [xx(3,1) yy(3,1) zz(3,1)];
    F = [xx(3,2) yy(3,2) zz(3,2)];
    G = [xx(3,3) yy(3,3) zz(3,3)];
    P = [xx(1,1) yy(1,1) zz(1,1)];
    % this surf function fills in the solid facets.
    surf(xx, yy, zz)
    % this chooses the strategy for coloring the surfaces
    colormap copper
    % these two makes the axes have the same spacing
    % and prevents the axis display
    axis equal
    axis off
    % This smoothes the color transitions
    shading interp
    % This defines the direction from which to view the cube
    view(-31, 22)
    % this hold the cube while the letters are drawn.
    hold on
    % These commands draw the visible letters.
    plot_text(A + [0, 0, 0.3], 'A');
    plot_text(B + [0, 0.1, 0.3], 'B');
    plot_text(C + [0.1, 0, 0], 'C');
    plot_text(D + [0, 0, 0.2], 'D');
    plot_text(E + [-0.3, 0, 0], 'E');
    plot_text(F + [-0.3, -0.1, 0], 'F');
    plot_text(G + [0, -0.2, 0], 'G');
    plot_text(P + [0.1, 0.3, 0.1], 'P');
    % This shines a light on the surface from the specified
    %   anfgles in degrees.
    lightangle(20, 45)
end

% a helper functiojn to draw the letters
function plot_text(A, str)
    text(A(1), A(2), A(3), str);
end

