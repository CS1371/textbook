% listing_07_6
% Connectivity of a structure
clear; clc
    data(1) = beam('A-1', 0.866, 0.5, ...
        {'A','A-2','A-3','D-1'} );
    data(2) = beam('A-2', 0, 1, ...
        {'A', 'A-3', 'B-1', 'B-2'} );
    data(3) = beam('A-3', 0.866, 1.5, ...
        {'A-1', 'A-2', 'B-1', 'D-1'} );
    data(4) = beam('B-1', 0.866, 2.5, ...
        {'A-2', 'A-3', 'B-2', 'B-3', 'D-1', 'D-2'} );
    data(5) = beam('B-2', 0, 3, ...
        {'A-2', 'A-3', 'B-1', 'B-3', 'C-1', 'C-2'} );
    data(6) = beam('B-3', 0.866, 3.5, ...
        {'B-1', 'B-2', 'C-1', 'C-2', 'D-1', 'D-2'} );
    data(7) = beam('C-1', 0.866, 4.5, ...
        {'B-2', 'B-3', 'C-2', 'C-3', 'D-2'} );
    data(8) = beam('C-2', 0, 5, ...
        {'B-2', 'B-3', 'C-1', 'C-3', 'C'} );
    data(9) = beam('C-3', 0.866, 5.5, ...
        {'C-1', 'C-2', 'D-2', 'C'} );
    data(10) = beam('D-1', 1.732, 2, ...
        {'A-1', 'A-3', 'B-1', 'B-3', 'D-2'} );
    data(11) = beam( 'D-2', 1.732, 4, ...
        {'B-1', 'B-3', 'C-1', 'C-3', 'D-1'} )
    conn = 'A';
    clist = {conn};
    while true
        index = 0;
        % find all the beams connected to conn
        for in = 1:length(data)
            str = data(in);
            if touches(str, conn)
                index = index + 1;
                found(index) = str;
            end
        end
        % eliminate those already connected
        for jn = index:-1:1
            if ison(found(jn).name, clist)
                found(jn) = [];
            else
                clist = [clist {found(jn).name}];
            end
        end
        if length(found) > 0
            conn = nextconn( found, clist );
        else
            break;
        end
    end
    disp('the order of assembly is:')
    disp(clist)

function ans = beam( nm, xp, yp, conn )
    % construct a beam structure with fields:
    % name - beam name
    % xp, yp - coordinates of its centroid
    % conn - cell array - names of adjacent beams
    % useage: ans = beam( nm, xp, yp, conn )
    ans.name = nm;
    ans.pos = [xp, yp];
    ans.connect = conn;
end

function res = touches(beam, conn)
    % does the beam touch this connecting point?
    % usage: res = touches(beam, conn)
    res = false;
    for in = 1:length(beam.connect)
        item = beam.connect{in};
        if strcmp(item,conn)
            res = true; break;
        end
    end
end

function res = ison( nm, cl )
    % is this beam on the connection list,
    % a cell array of beam names
    % usage: res = ison( beam, cl )
    res = false;
    for in = 1:length(cl)
        item = cl{in};
        if strcmp(item, nm)
            res = true; break;
        end
    end
end

function nm = nextconn( fnd, cl )
    % find a connection name among
    % those found not already connected
    % usage: nm = nextconn( fnd, cl )
    for in = 1:length(fnd)
        item = fnd(in);
        cn = item.connect;
        for jn = 1:length(cn)
            nm = cn{jn};
            if ~ison(nm, cl)
                break;
            end
        end
    end
end
