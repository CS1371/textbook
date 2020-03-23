% Analyzing ceramic composition
function main
    % Matrix A is the transpose of the original data table
    A = [0.6950	0.8970 0.0670 0.6920
        0.1750	0.0372	0.0230	0.0160
        0.0080	0.0035	0.0600	0.0250
        0.1220	0.0623	0.8500	0.2670]
    
    % Shows the required composition in kilograms
    B = [67 5 2	26].'
    
    % Shows the computed weights of the raw materials in kg, which produces
    % the following result:
        % W = [16.0083, 35.3043, 15.1766 33.5108]
    W = (inv(A) * B).'
end