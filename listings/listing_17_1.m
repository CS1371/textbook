% Listing 17.1: Testing Stacks, Queues, and Priority Queues
function main
%    Test a Stack
    stack = [];
    rv = round(rand(1,6)*100 - 25);
    stack = pushvec(stack, rv);
    sv = popvec(stack); 
    if length(rv) == length(sv) ...
        && all(sv == rv(end:-1:1))
        fprintf('Stack good\n');
    else
        fprintf('Stack bad!!!\n');
    end
%    Test a Queue
    rv = round(rand(1,5)*100 - 25);
    q = [];
    q = enqvec(q, rv);
    sv = deqvec(q); 
    if length(rv) == length(sv) ...
        && all(sv == rv) 
        fprintf('Queue good\n');
    else
        fprintf('Queue bad!!!\n');
    end
%    Test a Priority Queue
    rv = round(rand(1,5)*100 - 25);
    pq = [];
    pq = pqenqvec(pq, rv);
    sv = deqvec(pq); 
    if length(rv) == length(sv) ...
        && all(diff(sv) >= 0) 
        fprintf('Priority Queue good\n');
    else
        fprintf('Priority Queue bad!!!\n');
    end
end

function ans = is_before(a, b)
    acl = class(a);
    ans = false;
    if isa(b, acl)
        switch acl
            case {'double' 'logical' 'uint8'}
                ans = a < b;
            case 'char'
                ans = strcmp(a,b);
            case 'struct'
                if isfield(a, 'key')
                    ans = a.key < b.key;
                elseif isfield(a, 'dod')
                    ans = age(a) < age(b);
                else
                    error('comparing unknown structures')
                end
            otherwise
                error(['can''t compare ' acl 's'])
        end
    end
end

function v = popvec(stk)
% pop a vector from a stack
    v = [];
    while ~isempty(stk)
        [stk val] = pop(stk);
        v = [v val];
    end
end

function stk = pushvec(stk, V)
% push a vector onto a stack
    for v = V
        stk = push(stk, v);
    end
end

function v = deqvec(q)
% dequeue a vector from a queue
    v = [];
    while ~isempty(q)
        [q val] = deq(q);
        v = [v val];
    end
end

function q = enqvec(q, V)
% enqueue a vector on a queue
    for v = V
        q = enq(q, v);
    end
end

function q = pqenqvec(q, V)
% enqueue a vector on a priority queue
    for v = V
        q = pqenq(q, v);
    end
end

function s = push(s, data)
% push an item onto a stack
	s = [s {data}];
end

function [s ans] = pop(s)
% pop an item off a stack
	ans = s{end};
	s = s(1:(end-1));
end
    
function q = enq(q, data)
    % enqueue onto a queue
    q = [q {data}];
end

function [q ans] = deq(q)
    % dequeue an item from a queue
    ans = q{1};
    q = q(2:end);
end

function pq = pqenq(pq, item)
% enqueue in order to a priority queue
	in = 1;
	at = length(pq)+1;
	while in <= length(pq)
        if is_before(item, pq{in})
            at = in;
            break;
        end
        in = in + 1;
	end
	pq = [pq(1:at-1) {item} pq(at:end)];
end

