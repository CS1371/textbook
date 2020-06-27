function make_index
clc
    global line
    global debug
    global last_name
    global ndx
%     global data
    global files
    global state
    global current_ID
    global target
    global tg_sz
    
    target = 'for';
    tg_sz = length(target);
    % <a class="nav-link" href="Preface.htm">Preface</a>
    cd 'C:\Users\dmsmi\Documents\textbook\html_not_linked'
    state = 'Symbols';
    debug = fopen('../new_code/debug.log', 'w');
    data = [];
    ndx = 1;
    current_ID = 300;
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
        '17_Graphs.htm' ...
        'Appendix_A.htm' ...
        'Appendix_B.htm' ...
        'Appendix_C.htm' ...
        'Appendix_D.htm'};
    in = fopen('dms_index.txt','r');
    line = fgetl(in);
    last_name = '';
    while ischar(line)
        ndx = ndx + 1;
        if length(line) > 0
            ntry = process_line();
            write_entry(ntry);
            data = [data ntry];
        end
        line = fgetl(in);
    end
    data = seek_in_files(data);
    data = patch_up_children(data);
    show_index(data);
    fclose(debug);
    fprintf('Done!\n');
end


function write_entry(ntry)
    global debug
    fprintf(debug, '\nEntry type %c\n', ntry.type);
    fprintf(debug, ' first: %s\n', ntry.first);
    fprintf(debug, 'second: %s\n', ntry.second);
    fprintf(debug, ' third: %s\n', ntry.third);
    fprintf(debug, 'fourth: %s\n', ntry.fourth);
    fprintf(debug, 'fifth: %s\n', ntry.fifth);
    for ca = ntry.ref
        fprintf(debug,' - ''%s''\n', ca{1});
    end
end


% % 
% % patch_up_children()
% % 
    % an entry has fields:
    %   first - string: the first word matched
    %   second - string: the second word
    %   third - string: the third word
    %   fourth - string: the fourth word
    %   fifth - string: the fifth word
    %   type - H: this is a header
    %        - C: this is a child
    %        - S: this is a symbol
    %        - N: this is a normal entry
    %   ref - cell array of strings    
function data = patch_up_children(data) 
    global debug
%     global data
    
    lead_name = '';
    fprintf(debug, 'Patching Up Children\n');
    for ndx = 1:length(data)
        entry = data(ndx);
        if entry.type == 'N'
            lead_name = put_back_space(entry.first);
%             fprintf(debug, 'lead name is %s\n', lead_name);
        elseif entry.type == 'C' && ~isempty(lead_name)
            child_name = put_back_space(entry.first);
%             fprintf(debug, ' - child name is %s\n', child_name);
            % get Normal refs list
            found = false;
            for pndx = 1:length(data)
                parent = data(pndx);
                match = strcmp(put_back_space(parent.first), child_name);
                if parent.type == 'N' && match 
%                     fprintf(debug,'found parent %s of %s\n', ...
%                         parent.first, child_name);
                    found = true;
                    if ~isempty(parent.ref)
                        entry.ref = parent.ref;
                        data(ndx) = entry;
                    elseif ~isempty(entry.ref)
                        parent.ref = entry.ref;
                        data(pndx) = parent;
                    end
                    break;
                end
            end
            if ~found
                if strcmp( child_name, 'slicing')
                    ooh = 1;
                end
                fprintf(debug,'Couldn''t find parent of %s::%s\n', ...
                    lead_name, child_name);
            end
        end
    end
end    
    
    

    
% % 
% % seek_in_files()
% % 
function data = seek_in_files(data) 
    global files
    global last_marker
    global file_str
    
    last_marker = '';
%    for ndx = 1:length(files)
    for ndx = 1:length(files)
        name = files{ndx};
        fprintf('look in %s\n', name);
        file_str = fileread(name);
        if isempty(file_str)
            error(['file ' name ' ' not found']);
        end
        data = find_words(data, name);
        new_name = ['../html/' name];
        fid = fopen(new_name, 'w');
        fprintf(fid,'%s\n', file_str);
        fclose(fid);
    end
end





% % 
% % find_words
% % 
function data = find_words(data, name)
    
    for ndx = 1:length(data)
        entry = data(ndx);
        if entry.type == 'N' || entry.type == 'C'
            if any(entry.first == '_')
                ook = 1;
            end
            entry = find_whole_word(name, entry);
        end
        data(ndx) = entry;
    end
end




% % 
% % insert_link
% % 
function [entry plug_sz] = insert_link(word, at, file_name, entry)
    global file_str
    global current_ID
    global target
    global tg_sz
    
    refs = entry.ref;
    if length(refs) < 12
        current_ID = current_ID + 1;
        plug = sprintf('<a id="%d"></a>', current_ID);
        file_str = [file_str(1:at-1) plug file_str(at:end)];
        % add the reference in entry
        word = entry.first;
        if length(word) > tg_sz && all(word(1:tg_sz) == target)
            ook = 0;
        end
        str = sprintf('#%d', current_ID);
        new_ref = [file_name str];
        entry.ref = [entry.ref {new_ref}];
        plug_sz = length(plug);
    else
        plug_sz = 0;
    end
end




% % 
% % find_whole_word
% % 
function entry = find_whole_word(name, entry)
    global file_str
    
    found = false;
    word = entry.first;
    if length(word) > 5 && all(word(end-4:end) == '(...)')
        word = word(1:end-4);
    end
    catchit = 'format_control';
    get_name = '06_Strings.htm';
    n = length(catchit);
    if length(word) < n
        n = length(word);
    end
    if strcmp(word(1:n), catchit) && strcmp(get_name, name)
        ookk = true;
    end
    [first_token first_rest] = strtok(word, '_');
    if ~isempty(first_rest)
        oooh = true;
    end
    where = strfind(file_str, first_token);
    for ndx = 1:length(where)
        wh = where(ndx);
        
        % check if inside <...>
        found = is_not_html(wh);
        % check for beginning with space or start of line
        if found
            front_OK = wh == 1 || is_word_end(file_str(wh-1));
            at = wh + length(word);
            str = file_str(at:at+6);
            initial = ~strcmp(str,'<a id="');
            if initial
                back_OK = file_str(at-1) == '(' ...
                    || at > length(file_str) ...
                    || is_word_end(file_str(at));
                found = front_OK && back_OK;
                if found
                    rest = first_rest;
                    token = first_token;
                    wh = wh + length(token);
                    while found && ~isempty(token)   %% <<<<<<<<<<<<<<<<
                        [token rest] = strtok(rest, '_');
                        if ~isempty(token)
                            [nxt wh] = get_next_word(wh);
                            found = strcmp(token, nxt);
                        end
                    end
                    if found
                        [entry, plug_sz] = insert_link(word, at, name, entry);
                        where = where + plug_sz;
                    end
                end
            end
        end
    end
end




% % 
% % get_next_word(wh)
% % 
function [word wh] = get_next_word(wh)
    global file_str
    
    word = '';
    ch = file_str(wh);
    wh = wh + 1;
    % check for '<'
    while ch == '<'
        while ch ~= '>'
            ch = file_str(wh);
            wh = wh + 1;
        end
        ch = file_str(wh);
        wh = wh + 1;
    end
    % if so, skip past '>'
    while ch == ' '
        ch = file_str(wh);
        wh = wh + 1;
    end
    % check for alphabetic for first word
    if is_alpha(ch)
    % if so, keep on copying alphanumerics.
        while is_alphanumeric(ch)
            word = [word ch];
            ch = file_str(wh);
            wh = wh + 1;
        end
    end  
end 


% % 
% % is_alpha(ch)
% % 
function yes = is_alpha(ch)
    ch = lower(ch);
    yes = (ch >= 'a' && ch <= 'z');
end



% % 
% % is_alphanumeric(ch)
% % 
function yes = is_alphanumeric(ch)
    yes = is_alpha(ch);
    yes = yes || (ch >= '0' && ch <= '9');
end
    
    
% % 
% % put_back_space
% % 
function word = put_back_space(word)
if any(word == '_')
        word(word == '_') = ' ';
    end
end





% % 
% % is_not_html
% % 
function found = is_not_html(where)
    global file_str
    try
        % find nearest enclosing 13's
        left = 0;
        at = where - 1;
        while at > 0 && file_str(at) ~= char(10)
            if file_str(at) == '<',left = left + 1; end
            if file_str(at) == '>',left = left - 1; end
            at = at - 1;
        end
        right = 0;
        at = where + 1;
        while at <= length(file_str) && file_str(at) ~= char(13)
            if file_str(at) == '<',right = right + 1; end
            if file_str(at) == '>',right = right - 1; end
            at = at + 1;
        end
        found = left <= 0 && right <= 0;
    catch
        error('in is_not_html');
    end
end



% % 
% % is_word_end
% % 
function found = is_word_end(ch)
    found = ~any(ch == 'abcdefghijklmnopqrstuvwxyz(');
end




% %
% % process_line()
% % 
function ntry = process_line()
    global line
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
        type = 'H';
    elseif head
        state = 'Head';
        type = 'H';
    end
    fifth = '';
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
            if length(rest) > 0 && rest(1) == '('
                first = [first '(...)'];
            end
            [second rest] = strtok(rest, ' ()');
            if strcmp(second, 'see')
                state = 'Pointer';
                type = 'P';
                second = rest;
                third = '';
                fourth = '';
            else
                [third rest] = strtok(rest, ' ()');
                [fourth rest] = strtok(rest, ' ()');
            end
            ref = '';
            state = 'Normal';
        case 'Head'
            [first rest] = strtok(line, ' ()');
            second = '';
            third = '';
            fourth = '';
            ref = '';
            state = 'Normal';
    end
    try
        ntry = make_entry( type, first, second, third, fourth, fifth, ref);
    catch E
        E
        ooh = 'bad';
    end
end




% % 
% % make_entry(type, first, second, third, fourthref)
% % 
function it = make_entry(type, first, second, third, fourth, fifth, ref)
    % an entry has fields:
    %   first - string: the first word matched
    %   second - string: the second word
    %   type - H: this is a header
    %        - C: this is a child
    %        - S: this is a symbol
    %        - N: this is a normal entry
    %        - P: this is a forward pointer
    %   refs - cell array of strings
    global debug
    
    it.type = type;
    it.first = first;
    it.second = second;
    it.third = third;
    it.fourth = fourth;
    it.fifth = fifth;
    it.ref = [];
    if ~isempty(ref)
        it.ref = {ref};
    end
%     fprintf(debug, 'Entry: type = %s; first = %s; second = %s; third = %s; fourth = %s', ...
%          it.type, it.first, it.second, it.third, it.fourth, it.fifth);
%     if(~isempty(ref))
%         fprintf(debug, ', %s', it.ref{1});
%     end
%     fprintf(debug, '\n');
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
function show_index(data)
%     global data
    global target
    global tg_sz
    
    cd '../html/';
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
    fprintf(out, '<div>#top_nav#</div>\n');
    fprintf(out, '<div class="nav-obj">#nav_obj#</div>\n');
    fprintf(out, '<div class="content">\n');
    fprintf(out, '<h1 align="center" id="1">Index</h1>\n');
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

    for ndx = 1:length(data)
        entry = data(ndx);
        word = put_back_space(entry.first);
        if strcmp(entry.second, '...')
            entry.second = '';
        end
        switch entry.type
            case 'H'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <th colspan="07">%s</th>\n', ...
                    word);
                fprintf(out,'        </tr>\n');
            case 'N'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td>%-0s</td>\n', ...
                    [word ' ' entry.second ' ' entry.third ' ' entry.fourth]);
                for ndx = 1:length(entry.ref)
                    fprintf(out, ...
                       '<td><a href="%s"><span class="blackText">(%d)</span></a> </td>\n', ...
                        entry.ref{ndx}, ndx);
                end
                fprintf(out,'        <tr>\n');
            case 'P' % foward pointer - just show entry first and entry.second
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td>%-0s</td>\n', word);
                fprintf(out,'            <td colspan="20">%-0s</td>\n', ...
                    ['see ' put_back_space(entry.second)]);
                fprintf(out,'        <tr>\n');
            case 'S'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td>%-0s</td>\n', word);
                for ndx = 1:length(entry.ref)
                    fprintf(out, ...
                       '<td><a href="%s"><span class="blackText">(%d)</span></a> </td>\n', ...
                        entry.ref{ndx}, ndx);
                end
                fprintf(out,'        <tr>\n');
            case 'C'
                fprintf(out,'        <tr>\n');
                fprintf(out,'            <td> - %-0s</td>\n', ...
                    [word ' ' entry.second ' ' entry.third ' ' entry.fourth]);
                for ndx = 1:length(entry.ref)
                    fprintf(out,'<td><a href="%s"><span class="blackText">(%d)</span></a> </td>\n', ...
                        entry.ref{ndx}, ndx);
                end
                fprintf(out,'        <tr>\n');
        end
    end
    fprintf(out,'</table>\n');
    fprintf(out,'</div>\n');
    fprintf(out,'</body>\n');
    fprintf(out,'</html>\n');
    fclose(out);
end



