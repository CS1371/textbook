% Figure 11.7 done automatically
function main
clear
clc
close all
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
    A = [xx(2,1) yy(2,1) zz(2,1)];
    B = [xx(2,2) yy(2,2) zz(2,2)];
    C = [xx(2,3) yy(2,3) zz(2,3)];
    D = [xx(2,4) yy(2,4) zz(2,4)];
    E = [xx(3,1) yy(3,1) zz(3,1)];
    F = [xx(3,2) yy(3,2) zz(3,2)];
    G = [xx(3,3) yy(3,3) zz(3,3)];
    H = [xx(3,4) yy(3,4) zz(3,4)];
    P = [xx(1,1) yy(1,1) zz(1,1)];
    Q = [xx(4,1) yy(4,2) zz(4,3)];
    plot_line(A, B, 'b');
    plot_line(A, C, 'b');
    plot_line(B, C, 'b');
    plot_line(B, D, 'b');
    plot_line(C, D, 'b');
    plot_line(D, A, 'b');
    plot_line(A, E, 'b');
    plot_line(E, F, 'b');
    plot_line(F, B, 'b');
    plot_line(C, G, 'b');
    plot_line(F, G, 'b');
    plot_line(D, H, 'b--');
    plot_line(F, H, 'b--');
    plot_line(E, G, 'b--');
    plot_line(H, G, 'b--');
    plot_line(H, E, 'b--');
    plot_text(A + [0, 0, 0.3], 'A');
    plot_text(B + [0, 0.1, 0.3], 'B');
    plot_text(C + [0.1, 0, 0], 'C');
    plot_text(D + [0, 0, 0.2], 'D');
    plot_text(E + [-0.3, 0, 0], 'E');
    plot_text(F + [-0.3, -0.1, 0], 'F');
    plot_text(G + [0, -0.2, 0], 'G');
    plot_text(H + [0.1, 0, 0.1], 'H');
    plot_text(P + [0.1, 0.3, 0], 'P');
    plot_text(Q + [0, 0, -0.1], 'Q');
    axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end

function plot_text(A, str)
    text(A(1), A(2), A(3), str);
end
    
function plot_line(A, B, clr)
    x = [A(1), B(1)]; 
    y = [A(2), B(2)]; 
    z = [A(3), B(3)]; 
    plot3(x, y, z, clr)
    hold on
end
