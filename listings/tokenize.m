clear
clc

% string to process
str = 'area = 3.14159265 .* radius .^ 2';
while ~isempty(str) % repeat until the string is empty
    % put the first token into var_1
    % and put the remainder back into str
    [var_1, str] = strtok(str, ' ');
    [op_1, str] = strtok(str, ' ');
    [num_1, str] = strtok(str, ' ');
    [op_2, str] = strtok(str, ' ');
    [var_2, str] = strtok(str, ' ');
    [op_3, str] = strtok(str, ' ');
    [num_2, str] = strtok(str, ' ');
end
% convert the numbers
n_1 = str2num(num_1);
n_2 = str2num(num_2);
% confirm the meaning
fprintf('calculate %s by doing %s with %s and %d' , var_1, op_3, var_2, n_2);
fprintf(', then doing %s with the result and %1.4f\n', op_2, n_1);