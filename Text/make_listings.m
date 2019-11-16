function make_listings
    clc
    close all
    global fh
    global line
    global OK
    fh = fopen('listings.txt','r');
    line = '';
    OK = true;
    while OK
        process_listing()
    end
    fprintf('done\n\n')
    fclose(fh);
    !del outfile.txt
    diary('outfile.txt')
    run_all
    diary off;
end

function process_listing()
    global fh
    global line
    global OK
    global out
    
    OK = true;
    cd 'listings'
    !del *.* /Q
    cd ..
    while OK
        line = fgetl(fh);
        if ischar(line)
            if length(line) > 0 ...
                    && line(1) == 'L'
                go_on = true;
                while go_on
                    out = open_file(line);
                    go_on = process_one();
                end
            end
        else
            OK = false;
        end
        OK = false;
    end
end

function OK = process_one()
    global line
    global fh
    global out
    
    stop = false;
    OK = true;
    while OK && ~stop
        line = fgetl(fh);
        if ischar(line)
            if ~isempty(line)
                switch line(1)
                    case 'L'
                        stop = true;
                    case 'S'
                        stop = true;
                    case {'0','1','2','3','4','5','6','7','8','9'}
                        [~,line] = strtok(line);
                end
                if ~stop
                    fprintf(out, '%s\n', line);
                end
            end
        else
            OK = false;
        end
    end
    %    fprintf(out, 'end\n');
    fclose(out);
end


function fh = open_file(str)
    % str contains 'Listing ch.n purpose'
    %          or  'Shared name ch.n purpose'
    % construct name listings/Listing_ch_n
    % write %% purpose as its first line
    [lst,rest] = strtok(str, ' ');
    shared = strcmp(lst,'Shared')
    if shared
        [name rest] = strtok(rest, ' ');
        name = [name, '.m'];
    end
    [tkn,rest] = strtok(rest,' .');
    ch = str2num(tkn);
    [tkn,rest] = strtok(rest,' .');
    n = str2num(tkn);
    if ~shared
        name = sprintf('listing_%02d_%d.m', ch, n);
    end
    fh = fopen(['Listings/' name], 'w');
    if shared
        fprintf(fh, '%% Listing_%02d_%d %s\n', ch, n, rest);
    else
        fprintf(fh, '%%%s\n', rest);
    end
end


