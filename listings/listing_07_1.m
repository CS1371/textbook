% listing_07_1
% Using cell arrays of parameters
clear; clc
    A = 4;
    B = 6;
    C = 5;
    N = largest(A, B, C)
    params = { 4, 6, 5 };
    N = largest(params{1:3})

function it = largest(r, s, t)
    it = max([r s t]);
end
