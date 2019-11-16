% listing_02_2
% Script to compute the spacecraft's velocity
clear; clc
    % Define general knowledge with meaningful variable names to enable
    % subsequent use of these values without ambiguity.
    cmPerInch = 2.54;	% general knowledge
    inchesPerFt = 12;	% general knowledge
    metersPerCm = 1/100; % general knowledge
    % The conversion factor we need. Notice that because the variable names are
    % consistent with the logic, they help to avoid errors.
    MetersPerFt = metersPerCm * cmPerInch * inchesPerFt;
    % Develop the initial conditions with suitable units.
    startFt = 25000; % ft - given
    startM = startFt * MetersPerFt;
    % The standard value for the acceleration due to gravity.
    g = 9.81; % m/sec^2
    % the altitude of outer space is given in the problem statement.
    top = 100; % km - given
    % computes the distance traveled, including the unit conversion from
    % kilometers to meters. Note the optional, and in this case
    % unnecessary, use of parentheses to define the order of operations.
    s = (top*1000) - startM; % m
    % The final computation. The operator ^ is the MATLAB expression for exponentiation; x^y in MATLAB results in computing xy. Notice that the parentheses are required here to force the multiplication to happen before the exponentiation.
    initialV = (2*g*s)^0.5 % the final answer
