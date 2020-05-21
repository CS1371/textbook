function make_index
clc
    global line
    global debug
    global last_name
    global ndx
    global data
    global files
    global state
    
    % <a class="nav-link" href="Preface.htm">Preface</a>
    cd 'C:\Users\dmsmi\Documents\textbook\html'
    debug = fopen('debug.log', 'w');
    data = [];
    files = { ...
        'Preface.htm' ...
        '01_Introduction.htm' ...
        '02_Basics.htm' ...
        '03_Functions.htm' ...
        '04_Vectors.htm' ...
        '05_Execution.htm' ...
        '06_Strings.htm' ...
        '07_Structures.htm' ...
        '08_File_I_O.htm' ...
        '09_Recursion.htm' ...
        '10_Problem_Solving.htm' ...
        '11_Plotting.htm' ...
        '12_Matrices.htm' ...
        '13_Images.htm' ...
        '14_Sounds.htm' ...
        '15_Numerical_Methods.htm' ...
        '16_Sorting.htm' ...
        '17_Graphs.htm'};

    ndx = 0;
    in = fopen('dms_index.txt','r');
    line = fgetl(in);
    last_name = '';
    while ischar(line)
        ndx = ndx + 1;
        if length(line) > 0
            process_line()
        end
        line = fgetl(in);
    end
    
    seek_in_files();
    show_index();
    fclose(debug);
    fprintf('Done!\n');
end

function seek_in_files() 
    global files
    global debug
    global state
    
    for ndx = 1:length(files)
%    for ndx = 1:1
        name = files{ndx};
        fprintf('look in %s\n', name);
        in = fopen(name, 'r');
        if isempty(in)
            error(['file ' name ' ' not found']);
        end
        state  = 'find_body';
        line = fgetl(in);
        while ischar(line)
            process_file_line(line);
            line = fgetl(in);
        end
    end
end


function process_file_line(line)
    global state
    global debug
    global current_head
    
%    fprintf(debug, '%s\n', line); 
    switch state
        case 'find_body'
            if contains(line, '<body>');
                state = 'read_body';
            end
        case 'read_body'
            start = strfind(line, '<h');
            if ~isempty(start) 
                end_head = strfind(line(start(1):end), '>');
                h_end = strfind(line, '</h'); 
                current_head = line(end_head(1)+2:h_end(1)-1);
            end
            match_indices(line);
    end
end



function match_indices(line)
    global data
    global current_head
    
    for ndx = 1:length(data)
        entry = data(ndx);
        if length(entry.refs) < 5
            found = true;
            for tndx = 1:length(entry.tokens)
                token = entry.tokens{tndx};
                if ~contains(line, token)
                    found = false;
                    break;
                end
            end
            if found
                entry.refs = [entry.refs {current_head}];
                data(ndx) = entry;
            end
        end
    end
end




function show_index()
    global data
    global debug
    
    first = true;
    out = fopen('Index.htm', 'w');
    fprintf(out, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">\n');
    fprintf(out, '<html>\n');
    fprintf(out, '<head>\n');
    fprintf(out, '<meta name="GENERATOR" content="PageBreeze Free HTML Editor (http://www.pagebreeze.com)">\n');
    fprintf(out, '<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1" >\n');
    fprintf(out, '<meta name="viewport" content="width=device-width, initial-scale=1">\n');
    fprintf(out, '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">\n');
    fprintf(out, '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>\n');
    fprintf(out, '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>\n');
    fprintf(out, '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>\n');
    fprintf(out, '<link rel="stylesheet" href="styles/styles.css" />\n');
    fprintf(out, '<title>Index</title>\n');
    fprintf(out, '</head>\n');
    fprintf(out, '<body>\n');
% put this:
%    A. at the top of the table
%    B. whenever the current token is alone and is A - Z
% <table>
%     <thead>
%         <tr>
%             <th colspan="2">The table header</th>
%         </tr>
%     </thead>
%     <tbody>
% otherwise, do this
%         <tr>
%             <td>col 1</td>
%             <td>col 2</td>
%         </tr>
%     </tbody>
% </table>
    do_header = false;
    for entry = data
        if first
            %  put out Symbols header
            fprintf(out,'<table>\n');
            fprintf(out,'    <thead>\n');
            fprintf(out,'        <tr>\n');
            fprintf(out,'            <th colspan="7">Index</th>\n', ...
                entry.tokens{1});
            fprintf(out,'        </tr>\n');
            fprintf(out,'    </thead>\n');
            fprintf(out,'    <tbody>\n');
            first = false;
        end
        if length(entry.tokens) == 1 && length(entry.tokens{1}) == 1
            % found letter block start
            % if block_count is 1, could also be a symbol check for A-Z
            ch = entry.tokens{1};
            if ch >= 'A' && ch <= 'Z'
                do_header = true;
            end
        end
        if do_header
            fprintf(out,'    </tbody>\n');
            fprintf(out,'</table>\n');
            fprintf(out,'<table>\n');
            fprintf(out,'    <thead>\n');
            fprintf(out,'        <tr>\n');
            fprintf(out,'            <th colspan="7">%s</th>\n', ...
                entry.tokens{1});
            fprintf(out,'        </tr>\n');
            fprintf(out,'    </thead>\n');
            fprintf(out,'    <tbody>\n');
            do_header = false;
        else
            fprintf(out,'        <tr>\n');
            fprintf(out,'            <td>%-0s</td>\n', entry.see);
            fprintf(out,'            <td> %s</td>\n', entry.comment);
            for ndx = 1:length(entry.refs)
%                fprintf(out, '<td>%s</td>', entry.refs{ndx});
                if ndx < length(entry.refs)
                    fprintf(out,'            <td>%d,</td>\n', ndx);
                else
                    fprintf(out,'            <td>%d</td>\n', ndx);
                end
            end
            fprintf(out,'        <tr>\n');
        end
    end
    fprintf(out,'        </tr>\n');
    fprintf(out,'    </tbody>\n');
    fprintf(out,'</table>\n');
    fprintf(out,'</body>\n');
    fprintf(out,'</html>\n');
end


function process_line()
    global line
    global debug
    global last_name
    global ndx
    global data
    global comment_there
    
%     fprintf(debug, '%s\n', line);
    pound_at = strfind(line, '#');
    if isempty(pound_at) 
        str = sprintf('line[%d] has no #', ndx);
        error(str);
    end
    do_line = line(1:pound_at(1) - 1);
    token = [];
    child = ischild();
    if child
        do_line = do_line(3:end);
    end
    start_comment = strfind(do_line, '(');
    comment = '';
    if isempty(start_comment) 
        start_comment = length(do_line) + 1;
        comment_there = false;
    else
        end_comment = strfind(do_line, ')');
        comment = do_line(start_comment(1)+1:end_comment(1)-1);
        comment_there = true;
    end
    ln = do_line(1:start_comment-1);
    ntry = make_entry(ln, comment, child);
    data = [data ntry];
    fprintf(debug, '%5d::%-0s %-20s', ndx, ntry.see, ntry.comment);
    for it = 1:length(ntry.tokens)
        fprintf(debug, '; %s', ntry.tokens{it});
    end
    fprintf(debug,'\n');
    if ndx == 34
        gotcha = true;
    end
end

function it = make_entry(lk, cm, ch)
    global debug
    global ndx
    global comment_there
    
    it.seek = lk;
    it.comment = cm;
    if ch
        it.see = [' - ' it.seek];
    else
        it.see = it.seek;
    end
    if comment_there && isempty(cm)
        it.see = [it.see '(...)'];
    end
    it.refs = [];
    it.tokens = [];
    ln = lk;
    while ~isempty(ln)
        [tkn ln] = strtok(ln,' ,');
        if ~isempty(tkn)
            it.tokens = [it.tokens {tkn}];
        end
    end
%     fprintf(debug, 'see = %s; seek = %s; comment = %s\n', ...
%         it.see, it.seek, it.comment);
end

function yes = ischild()
    global line
    
    yes = false;
    yes = length(line) > 1 && all(line(1:2) == ' &');
end