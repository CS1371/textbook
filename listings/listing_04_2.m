% listing_04_2
% Script to solve vector problems
clear; clc; close all
    % Typical initial values for the problem.
    PA = [0 1 1];
    PB = [1 1 0];
    P = [2 1 1]
    A = P + PA
    B = P + PB
    M = [4 0 1]
    % find the resultant of PA and PB
    PC = PA + PB;
    C = P + PC
    % find the unit vector in the direction of PC
    % The unit vector along PC is PC divided by its magnitude. The magnitude is
    % the square root of the sum of the squares of the individual components.
    mag = sqrt(sum(PC.^2));
    unit_vector = PC/mag;
    % find the moment of the force PC about M
    % this is the cross product of MP and PC
    % The vector MP is the vector difference between P and M.
    MP = P - M;
    % There is a built-in function, cross(..), to compute the cross product
    %  of two vectors.
    mom = cross( MP, PC )
    my_quiv([0 0 0], P, 'r-','P', true) %O-P
    hold on
    text(0, 0, 0,'O')
    my_quiv([0 0 0], [5 0 0], 'k-', 'X axis', true) % x axis
    my_quiv([0 0 0], [0 4 0], 'k-', 'Y axis', true) % y axis
    my_quiv([0 0 0], [0 0 3], 'k-', 'Z axis', true) % z axis
    my_quiv(P, A, 'r-', 'A', true)   % P-A
    my_quiv(P, B, 'g-', 'B', true)   % P-B
    my_quiv(P, C, 'b--', 'C', true)   % P-C
    my_quiv(M, P, 'm--', 'M', false)   % M-P
    my_quiv(P, mom, 'c:', 'momentum', true)   % P-mom
    axis([-1 5 -1 4 -6 3])
    grid off
    
function my_quiv(A, B, ln, txt, fwd)
    fprintf('[%d %d %d] -> [%d %d %d] %s %s\n', ...
        A(1), A(2), A(3), B(1), B(2), B(3), ln, txt)
    quiver3(A(1), A(2), A(3), B(1), B(2), B(3), ln)
    if fwd
        text(B(1), B(2), B(3), txt)
    else
        text(A(1), A(2), A(3), txt)
    end
end
    
