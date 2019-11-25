% listing_02_1
% Script to solve for the hypotenuse of a right triange
clear
clc
    % Assign values to A and B. The semicolons prevent MATLAB from displaying
    % the result in the Command window; the percent sign begins the legible
    % comment. Lines may contain nothing but a comment.
    A = 3;	% the first side of a triangle
    B = 4;	% the second side of a triangle
    % Intermediate results with suitable names sometimes improve the legibility
    % of the algorithm.
    hypSq = A^2 + B^2;	% the square of the
    % hypotenuse
    % invoke the built-in library function sqrt(...) to compute the final result.
    H = sqrt(hypSq)	    % the answer

