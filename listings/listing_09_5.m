% The Fibonacci function
function main
    tic
    res = fib(35);
    fprintf('fib(35) took %1.4f seconds; answer = %d\n', toc, res);
end
function result = fib(N)
    % recursive computation the Nth Fibonacci number
    if N == 1 || N == 2
        result = 1;
    else
        result = fib(N-1) + fib(N-2);
    end
end
