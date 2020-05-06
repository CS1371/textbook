% listing_04_1
% Vector indexing script
function main
    % Create a vector A with six elements.
    A = [2 5 7 1 3 4];
    % When predefining an index vector, if you want to refer to the size of a
    % vector, you must use either the length(...) function or the size(...)
    % function.
    odds = 1:2:length(A);
    % The disp(...) function shows the contents of its parameter in the
    % Interactions window, in this case: 'odd values of A using predefined
    % indices'. We use disp(...) rather than comments because comments are
    % visible only in the script itself, not in the program output, which we
    % need here.
    disp('odd values of A using predefined indices')
    % Using a predefined index vector to access elements in vector A.
    % Since no assignment is made, the variable ans takes on the value
    % of a three-element vector containing the odd-numbered elements of
    % A. Notice that these are the odd-numbered elements, not the
    % elements with odd values.
    A(odds)
    disp('odd values of A using anonymous indices')
    % The anonymous version of the command given in Line 4. Notice that the
    % anonymous version allows you to use the word end within the vector meaning
    % the index of its last element.
    A(1:2:end)
    disp('put evens into odd values in a new array')
    % Since B did not previously exist (a good reason to run the clear command
    % at the beginning of a script is to be sure this is true), a new vector is
    % created with five elements (the largest index assigned in B). Elements in
    % B at positions less than five that were not assigned are zero filled.
    B(odds) = A(2:2:end)
    disp('set the even values in B to 99')
    % If you assign a scalar quantity to a range of indices in a vector, all
    % values at those indices are assigned the scalar value.
    B(2:2:end) = 99
    disp('find the small values in A')
    % Logical operations on a vector produce a vector of Boolean results. This
    % is not the same as typing small = [1 0 0 1 1 0] . If you want to create a
    % logical vector, you must use true and false, for example:
    %       small = [true false false true true false]
    small = A < 4
    disp('add 10 to the small values')
    % This is actually performing the scalar arithmetic operation + 10
    % on an anonymous vector of three elements, and then assigning those
    % values to the range of elements in A.
    A(small) = A(small) + 10
    disp('this can be done in one ugly operation')
    % Not only is this unnecessarily complex, but it is also less efficient
    % because it is applying the logical operator to A twice. It is better to
    % use the form above.
    A(A < 10) = A(A < 10) + 10
end
