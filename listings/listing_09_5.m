% The Fibonacci function
function main
    tic
    res = fib(32);
    fprintf('fib(32) took %1.4f seconds\n', toc);
end
function result = fib(N)
    % recursive computation the Nth Fibonacci number
    if N == 1 || N == 2
        result = 1;
    else
        result = fib(N-1) + fib(N-2);
    end
end
