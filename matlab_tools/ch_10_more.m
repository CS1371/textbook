clear
clc
str = 'In general, the built-in sort function can sort either a vector (of numbers, of course) or a cell array with either one row or one column containing strings.'
ca = [];
while ~isempty(str)
    [token str] = strtok(str, ' ,().');
    if(~isempty(token))
        ca = [ca {token}];
    end
end
ca
[sorted order] = sort(ca)