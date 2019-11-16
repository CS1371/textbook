% Simple solid cube
function main
    pause(1)
    figure
    xx = [  0  0  0  0  0  % P-P-P-P-P
        -1 -1  1  1 -1 % A-B-C-D-A
        -1 -1  1  1 -1 % E-F-G-H-E
        0 0 0 0 0] % Q-Q-Q-Q-Q
    yy = [  0  0  0  0  0  % P-P-P-P-P
        1 -1 -1 1 1 % A-B-C-D-A
        1 -1 -1 1 1 % E-F-G-H-E
        0 0 0 0 0] % Q-Q-Q-Q-Q
    zz = [  1  1  1  1  1  % P-P-P-P-P
        1 1 1 1 1 % A-B-C-D-A
        -1 -1 -1 -1 -1 % E-F-G-H-E
        -1 -1 -1 -1 -1] % Q-Q-Q-Q-Q
    surf(xx, yy, zz)
    colormap bone
    axis equal
    shading interp
    view(-36, 44)
    axis off
end
