% The insertion sort function
function main
    vec = round((rand(1,7)-0.5) .* 100);
    vs = insertionsort(vec);
end
function b = insertionsort(a)
    % This function sorts a column vector,
    % using the insertion sort algorithm
    b = []; i = 1; sz = length(a);
    while i <= sz
        b = insert(b, a(i) );
        i = i + 1;
    end
end
function a = insert(a, v)
    % insert the value v into column vector a
    i = 1; sz = length(a); done = false;
    while i <= sz
        if v < a(i)
            done = true;
            a = [a(1:i-1) v a(i:end)];
            break;
        end
        i = i + 1;
    end
    if ~done
        a(end+1) = v;
    end
end
