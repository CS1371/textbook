function make_index
clc
    global line
    global debug
    global last_name
    global ndx
    global data
    global files
    global symbol
    
    cd 'C:\Users\dmsmi\Documents\textbook\html'
    debug = fopen('../debug.log', 'w');
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
    symbol = true;
    in = fopen('dms_index.txt','r');
    line = fgetl(in); % get rid of Symbol#
    data = [data make_entry(line(1:end-1), '', '', true)];
    line = fgetl(in);
    while ischar(line)
        ndx = ndx + 1;
        if length(line) > 0
            process_line()
        end
        line = fgetl(in);
    end
    
%     seek_in_files();
    show_index();
%     fclose(debug);
%     fprintf('Done!\n');
end

function show_entry(out, me)
    
    if me.header
        fprintf(out,'<tr><th>%s</th><tr>\n', me.item);
    else
        fprintf(out,'<tr><td>%s </td><td>%s </td>', me.item, me.description);
        for ndx = 1:length(me.pointers)
            tndx = sprintf('%d', ndx);
            str = sprintf('<td class="nav-item"><a class="nav-link" href="%s">%s</a></td>', ...
                me.pointers{ndx}, tndx);
            fprintf(out, str);
        end
        fprintf(out,'</tr>\n');
    end
% <li class="nav-item"><a class="nav-link" href="..\..\index.html">Home</a></li>
%     me.item = it;
%     me.header = hdr;
%     me.description = descr;
%     me.pointers = ch;
    
end


function show_index
    global data
    
    out = fopen('text_index.htm','w');
    fprintf(out, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">\n');
    fprintf(out, '<html>\n');
    fprintf(out, '<head>\n');
    fprintf(out, '<meta name="GENERATOR" content="PageBreeze Free HTML Editor (http://www.pagebreeze.com)">\n');
    fprintf(out, '<meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-1" >\n');
    fprintf(out, '<meta name="viewport" content="width=device-width, initial-scale=1">\n');
    fprintf(out, '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">\n');
    fprintf(out, '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>\n');
    fprintf(out, '<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>\n');
    fprintf(out, '<link rel="stylesheet" href="styles/styles.css" />\n');
    fprintf(out, '<title>Index</title>\n');
    fprintf(out, '</head>\n');
    fprintf(out, '<body>\n');
    fprintf(out, '<div>#top_nav#</div>\n');
    fprintf(out, '<div class="nav-obj">#nav_obj#</div>\n');
    fprintf(out, '<div class="content">\n');
    fprintf(out, '<h1 align="center" id="1">Index</h1>\n');
    fprintf(out, '<table>\n');
    for entry = data
        show_entry(out, entry)
    end
    
    fprintf(out, '</table>\n');
    fprintf(out, '</div>\n');
    fprintf(out, '</body>\n');
    fprintf(out, '</html>\n');
    fclose(out);
end


function process_line()
    global line
    global debug
    global symbols
    global ndx
    global data
    global comment_there
    
%     fprintf(debug, '%s\n', line);
    pound_at = strfind(line, '#');
    if isempty(pound_at) 
        str = sprintf('line[%d] has no #', ndx);
        error(str);
    end
    if isHeader(line)
        data = [data make_entry(line(1:end-1), '', '', true)]; 
        symbols = false;
    elseif isChild(line)
        % fix up a child
    else
        % .'  scalar transpose ## 4.2.5 Operating on Vectors
        [item rest] = strtok(line, ' ');
        [descr rest] = strtok(rest, '#');
        back_end = pound_at(end);
        pointer = line(back_end+1:end);
        data = [data make_entry(item, descr, pointer, false)];
    end
end


function res = isChild(line)
    if length(line) >= 3 ...
        && line(1) == ' ' ...
        && line(2) == '&' ...
        && line(3) == ' '
        res = true;
    else
        res = false;
    end
end



function res = isHeader(line)
    if length(line) == 2 ...
        && line(2) == '#' ...
        && line(1) >= 'A' ...
        && line(1) <= 'Z'
        res = true;
    else
        res = false;
    end
end

function me = make_entry(it, descr, ch, hdr)
    global debug
    global ndx
    
    me.item = it;
    me.header = hdr;
    me.description = descr;
    me.pointers = {ch};
    fprintf(debug, '%s %d %s %s\n', me.item, me.header, ...
        me.description, me.pointers{1});
end

