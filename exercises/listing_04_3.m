% listing_04_3
% Array manipulation script
function main
    % Create a 2 X 4 array A.
    A = [2 5 7 3
        1 3 4 2]
    % Determine the number of rows and columns
    [rows, cols] = size(A)
    % Builds a vector odds containing the indices of the odd numbered columns.
    odds = 1:2:cols
    disp('odd columns of A using predefined indices')
    % Uses odds to access the columns in A. The : specifies that this is
    % using all the rows.
    A(:, odds)
    disp('odd columns of A using anonymous indices')
    % The anonymous version of the line above. Notice that you can use
    % the keyword 'end' in any dimension of the array to represent the
    % last index on that dimension.
    A(end, 1:2:end)
    disp('put evens into odd values in a new array')
    % Because B did not previously exist (a good reason to have 'clear'
    % at the beginning of the script to be sure this is true), a new
    % array is created. Elements in B that were not assigned are zero filled.
    B(:, odds) = A(:, 2:2:end)
    disp('set the even values in B to 99')
    % Puts 99 into selected locations in B.
    B(1, 2:2:end) = 99
    disp('find the small values in A')
    % Logical operations on arrays produce an array of logical results.
    small = A < 4
    disp('add 10 to the small values')
    % Add 10 to the values in A that are small.
    A(small) = A(small) + 10
    disp('this can be done in one ugly operation')
    % Not only is this unnecessarily complex, but it is also less efficient
    % because it is applying the logical operator to A twice.
    A(A < 4) = A(A < 4) + 10
    % The function find(...) actually returns a column vector of the index
    % values in the linearized version of the original array, as shown
    % in Exercise 3.16
    small_index = find(small)
    % As illustrated in the lines, it is not necessary to use find(...)
    % before indexing an array. However, this command does work.
    A(small_index) = A(small_index) + 100
end
