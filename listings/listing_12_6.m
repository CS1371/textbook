% Analyzing an electrical circuit
function main
    R1 = 100; R2 = 200; R3 = 300;
    R4 = 400; R5 = 500;
    V1 = 10; V2 = 5;
    A = [R1+R4	-R4	0
        -R4	R2+R4+R5 -R5
        0	-R5	R3+R5];
    B = [V1; 0; -V2];
    curr = inv(A) * B
    fprintf('drop across R1 is %6.2f volts\n', ...
        curr(1) * R1 );
end
