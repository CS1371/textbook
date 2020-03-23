% Analyzing an electrical circuit
function main
    % Set up the parameters of the problem.
    R1 = 100; R2 = 200; R3 = 300;
    R4 = 400; R5 = 500;
    V1 = 10; V2 = 5;
    
    % Set up the coefficient matrices
    A = [R1+R4	-R4	0
        -R4	R2+R4+R5 -R5
        0	-R5	R3+R5];
    B = [V1; 0; -V2];
    
    % Compute and display the answers
    curr = inv(A) * B
    fprintf('drop across R1 is %6.2f volts\n', ...
        curr(1) * R1 );
end

% Running this produces the following printout:
    % curr = [0.0283, 0.0104, 0.0003]
    % drop across R1 is 2.83 volts