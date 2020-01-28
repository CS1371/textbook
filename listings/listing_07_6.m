% listing_07_6
% Connectivity of a structure
clear; clc

global adj
global beams
% describe the structure as an adjacency list identifying for each
% node 'A'-'G' the notes to which it directly connects
adj = [];
adj = [adj, struct('from', 'A', 'to', {{'B', 'E'}})];
adj = [adj, struct('from', 'B', 'to', {{'A', 'C', 'E', 'F'}})];
adj = [adj, struct('from', 'C', 'to', {{'B', 'D', 'F', 'G'}})];
adj = [adj, struct('from', 'D', 'to', {{'C', 'G'}})];
adj = [adj, struct('from', 'E', 'to', {{'A', 'B', 'F'}})];
adj = [adj, struct('from', 'F', 'to', {{'B', 'C', 'E', 'G'}})];
adj = [adj, struct('from', 'G', 'to', {{'C', 'D', 'F'}})];
% Don't worry about exactly why this algorithm works
% It is actually a search for "strongly connected components" (SCC's)
% described in the Corman, Leiserson, Rivest text
% "Introduction to Algorithms" pp 488-493
% this is the algorithm:
% 1. compute u, a Depth First Search (DFS: Para 7.4.2), storing the
%    finish order f(u)
% 2. compute a DFS using f(u) in descending order finish times d(u)
% 3. compute fi(u), the forefather of each node in u defined as that
%    node w connected to u with the maximum value of f(w). Note: to
%    get this right, u can connect to itself
% 4. all the nodes in u with the same forefather form one of the
%    groups of SCC's 
% 5. select the beams for each group that connect the group's 
%    forefather to all the other nodes. 
%
% so here we go
%    set all nodes to 'not used' except A
at = 1;
finish = 0;
N = length(adj);
for ndx = 1:N
    adj(ndx).used = false;
end
% construct a list of beams
beams = [];
for ndx = 1:length(adj)
    fr = adj(ndx).from;
    ca = adj(ndx).to;
    for c = ca
        bm = [fr c{1}];
        if ~is_beam(bm)
           beams = [beams {bm}]; 
        end
    end
end
adj(1).used = true;
adj(1).f = finish;
u(1) = 1;
nxt = 1;
% fprintf('u(%d) = %c; f(%d) = %d\n', 1, adj(1).from, 1, adj(1).f); 
% 1. DFS starting at A, choosing the first child reachable from 
%    the current node u storing the finish time f(u)
for ndx = 2:N
    nxt = get_DFS_next(nxt);
    finish = finish + 1;
    adj(nxt).used = true;
    u(nxt) = nxt;
    adj(nxt).f = finish;
%     fprintf('u(%d) = %c; f(%d) = %d\n', ...
%         ndx, adj(nxt).from, ndx, adj(nxt).f); 
end
% 2. compute a DFS using f(u) in descending order finish times d(u)
f_vals = [adj.f];
finish = 0;
for ndx = 1:N
    at = find(f_vals == (7 - ndx));
    v(ndx) = at;
    adj(at).d = finish;
    finish = finish + 1;
%     fprintf('v(%d) = %c; d(%d) = %d\n', ...
%         ndx, adj(at).from, ndx, adj(at).d); 
end
% 3. compute fi(u), the forefather of each node in u defined as that
%    node w connected to u with the maximum value of f(w). Note: to
%    get this right, u can connect to itself

for ndx = 1:N
    ca = [{adj(ndx).from, adj(ndx).to{:}}];
    it = [];
    ord = [];
    for c = ca
        jk = c{1} - 'A' + 1;
        ord = [ord jk];
        it = [it adj(jk).f];
    end
    [~, at] = max(it);
    choice = ca{at} - 'A' + 1;
    adj(ndx).fi = choice;
end
finx = [adj.fi];
fi = char(finx + 'A' - 1);
% 4. all the nodes in u with the same forefather form one of the
%    groups of SCC's 
at = [];
ca = {adj.from};
foref = [];
for ndx = 1:7
    if any(finx == ndx)
        grp = ca(finx == ndx);
        at = [at {grp}];
        foref = [foref ndx];
    end
end
% 5. a. select the beams for each group that connect the group's 
%    forefather to all the other nodes. 
%    b. select the beams totally within the emerging collection
%    of nodes
save_bms = [];
all_nodes = [];
for gndx = 1:length(at)
    ff = foref(gndx);
    ca = at{gndx};
    all_nodes = [all_nodes ca];
    fprintf('group %d = {', gndx);
    for nx = 1:length(ca)
        fprintf(' %s', ca{nx});
        beam = [adj(ff).from, ca{nx}];
        save_bms = add_beam(save_bms, beam);
    end
    fprintf(' }\n');
% also save all beams with both ends in all_nodes
    for nx = 1:length(all_nodes)
        for ny = nx+1:length(all_nodes)
           bm = [all_nodes{nx} all_nodes{ny}];
           save_bms = add_beam(save_bms, bm);
        end
    end
end
% display the answers
fprintf('Beams should arrive in this order:\n');
for bm = save_bms
    b = bm{:};
    fprintf('%c-%c ', b(1), b(2));
end
fprintf('\n');

function bms = add_beam(bms, beam)
    if is_beam(beam)
        % check if it's already there
        rev = [beam(2) beam(1)];
        if ~(any(strcmp(bms, beam))||any(strcmp(bms, rev)))
            bms = [bms {beam}];
        end
    end
end

function is = is_beam(str)
    global beams
    is = false;
    rev = [str(2) str(1)];
    for ndx = 1:length(beams)
        if strcmp(beams{ndx}, str) || strcmp(beams{ndx},rev)
            is = true;
            break;
        end
    end
end

function res = get_DFS_next(u)
    global adj;
    ca = adj(u).to;
    to_ndx = 1;
    at = ca{to_ndx} - 'A' + 1;
    while adj(at).used
        to_ndx = to_ndx + 1;
        at = ca{to_ndx} - 'A' + 1;
    end
    res = at;
end
