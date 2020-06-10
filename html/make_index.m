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
    state = 'Symbols';
    debug = fopen('debug.log', 'w');
    data = [];
    ndx = 1;
    files = { ...
        'Appendix_A.htm' ...
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
    in = fopen('dms_index.txt','r');
    line = fgetl(in);
    last_name = '';
    while ischar(line)
        ndx = ndx + 1;
        if length(line) > 0
            ntry = process_line()
            data = [data ntry];
        end
        line = fgetl(in);
    end
%     seek_in_files();
    show_index();
    fclose(debug);
    fprintf('Done!\n');
end


% % 
% % process_line()
% % 
function ntry = process_line()
    global line
    global debug
    global last_name
    global ndx
    global data
    global comment_there
    global state
    
    symhead = strcmp(line, 'Symbols#');
    head = length(line) == 2 && line(2) == '#';
    pound_at = strfind(line, '#');
    if ~isempty(pound_at) 
        line = line(1:pound_at(1) - 1);
    end
    type = state(1); 
    child = ischild();
    if child
        type = 'C';
        line = line(4:end);
    elseif symhead
        type = 'H'
    elseif head
        state = 'Head';
        type = 'H';
    end
    switch(state)
        case 'Symbols'
            [first rest] = strtok(line, ' ()');
            first(first == '!') = '''';
            [second rest] = strtok(rest, ' ()');
            [third rest] = strtok(rest, ' ()');
            [fourth rest] = strtok(rest, ' ()');
            [fifth rest] = strtok(rest, ' ()');
            if isempty(fourth)
                ref = [];
            else
                ref = [fourth '#' fifth];
            end
        case 'Normal'
            [first rest] = strtok(line, ' ()');
            [second rest] = strtok(rest, ' ()');
            [third rest] = strtok(rest, ' ()');
            ref = '';
        case 'Head'
            [first rest] = strtok(line, ' ()');
            second = '';
            third = '';
            ref = '';
            state = 'Normal';
    end
    ntry = make_entry( type, first, second, third, ref);
end


% % 
% % make_entry(type, first, second, third, ref)
% % 

function it = make_entry(type, first, second, third, ref)
    % an entry has fields:
    %   first - string: the first word matched
    %   second - string: the second word
    %   type - H: this is a header
    %        - C: this is a child
    %        - S: this is a symbol
    %        - N: this is a normal entry
    %   refs - cell array of strings
    global debug
    global ndx
    global comment_there
    
    it.type = type;
    it.first = first;
    it.second = second;
    it.third = third;
    it.ref = [];
    if ~isempty(ref)
        it.ref = {ref};
    end
    fprintf(debug, 'Entry: type = %s; first = %s; second = %s; third = %s', ...
         it.type, it.first, it.second, it.third);
    if(~isempty(ref))
        fprintf(debug, ', %s', it.ref{1});
    end
    fprintf(debug, '\n');
end


% % 
% % seek_in_files()
% % 
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


% % 
% % process_file_line(line)
% % 
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

% % 
% % match_indices(line)
% % 
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


% % 
% % ischild()
% % 
function yes = ischild()
    global line
    
    yes = false;
    yes = length(line) > 2 && all(line(1:3) == ' & ');
end


% % 
% % show_index()
% % 
function show_index()
    global data
    global debug
    
    out = fopen('text_index.htm', 'w');
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
    fprintf(out, '<style>\n');
    fprintf(out, '.blackText\n');
    fprintf(out, '{\n');
    fprintf(out, '    color:black;\n');
    fprintf(out, '}\n');
    fprintf(out, '</style>\n');
    fprintf(out, '<title>Index</title>\n');
    fprintf(out, '</head>\n');
    fprintf(out, '<body>\n');
    fprintf(out, '<table>\n');
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
% <table>
% <tr><th>Symbols</th><tr>
% <tr><td>.! </td><td>  scalar transpose  </td><td><a href="01_Introduction.htm#1_1"><span class="blackText">1.1 Background</span></a></td></tr>
% </table>

    for entry = data
        switch entry.type
            case 'H'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <th colspan="7">%s</th>\n', ...
                    entry.first);
                fprintf(out,'        </tr>\n');
            case {'N', 'S'}
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td>%-0s</td>\n', entry.first);
                fprintf(out,'            <td> %s</td>\n', ...
                    [entry.second ' ' entry.third]);
                for ndx = 1:length(entry.ref)
                    fprintf(out, ...
                       '<td><a href="%s"><span class="blackText">(%d)</span></a></td>\n', ...
                        entry.ref{ndx}, ndx);
                    if ndx < length(entry.ref) 
                        fprintf(out,', ');
                    end
                end
                fprintf(out,'        <tr>\n');
            case 'C'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td> - </td>\n', entry.first);
                fprintf(out,'            <td> %s</td>\n', ...
                    [entry.second ' ' entry.third]);
                for ndx = 1:length(entry.ref)
                    fprintf(out,'<td><a href="%s">(%d)</a></td>\n', ...
                        entry.ref{ndx}, ndx);
                    if ndx < length(entry.ref) 
                        fprintf(out,', ');
                    end
                end
                fprintf(out,'        <tr>\n');
        end
    end
    fprintf(out,'</table>\n');
    fprintf(out,'</body>\n');
    fprintf(out,'</html>\n');
end



