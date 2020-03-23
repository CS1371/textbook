% listing_09_3
% Wrapper implementation for the factorial function
function main
    r1 = fact(10);
    try, r2 = fact(-3);
    catch exc, er = getReport(exc),	end
    try, r2 = fact(-3);
    catch exc, er = getReport(exc),	end
end

function result = fact(N)
    % computation of N!
    if (N < 0) || ((N - floor(N)) > 0) % Look for negative or fractional parts of N
        error('bad parameter for fact'); % If found, exit with error
    else % Otherwise, call helper function where real recursion happens
        result = r_fact(N);
    end
end

% Recursive helper function
function result = r_fact(N)
    % recursive computation of N!
    fprintf('fact( %d )\n', N); % Diagnostic printing enabled
    if N == 0 % Check terminating condition
        result = 1; % Terminating action
    else
        result = N * r_fact(N - 1); % Recursive call
    end
end
