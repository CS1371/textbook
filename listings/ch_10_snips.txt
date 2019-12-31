ins = 1;  % initialize the result<br>
% set up the first pass of the while loop
while ins <= length(v) && before(item, v(ins))<br>
% you provide a function before(a, b) that returns<br>
%   true if a comes before b in your ordering<br>
ins = ins + 1; % next value<br>
end<br>
% when you find the right place, concatenate the three parts
v = [v(1:ins-1) item v(ins:end)]<br><br>
