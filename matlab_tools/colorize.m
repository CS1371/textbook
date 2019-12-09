clear
clc
    global dbg
    
    dbg = fopen('debug.log','w');

%     format('test_coloring.m');
%     format('all_run.m');
%     format('all_run_really.m');
%     format('buildData.m');
%     format('CAToString.m');
%     format('f.m');
%     format('fix_nulls.m');
%     format('grAdjacency.m');
%     format('grBFS.m');
%     format('grDFS.m');
%     format('grDijkstra.m');
%     format('Greedy.m');
%     format('is_before.m');
%     format('listing_02_1.m');
%     format('listing_02_2.m');
%     format('listing_03_1.m');
%     format('listing_03_2.m');
%     format('listing_03_3.m');
%     format('listing_04_1.m');
%     format('listing_04_2.m');
%     format('listing_04_3.m');
%     format('listing_04_4.m');
%     format('listing_04_5.m');
%     format('listing_05_1.m');
%     format('listing_05_2.m');
%     format('listing_05_3.m');
%     format('listing_05_4.m');
%     format('listing_05_5.m');
%     format('listing_05_6.m');
%     format('listing_05_7.m');
%     format('listing_05_8.m');
%     format('listing_05_9.m');
%     format('listing_06_1.m');
%     format('listing_06_2.m');
%     format('listing_07_1.m');
%     format('listing_07_2.m');
%     format('listing_07_3.m');
%     format('listing_07_4.m');
%     format('listing_07_5.m');
%     format('listing_07_6.m');
%     format('listing_08_1.m');
%     format('listing_08_2.m');
%     format('listing_08_3.m');
    format('listing_08_4.m');
%     format('listing_09_1.m');
%     format('listing_09_2.m');
%     format('listing_09_3.m');
%     format('listing_09_4.m');
%     format('listing_09_5.m');
%     format('listing_09_6.m');
%     format('listing_09_7.m');
%     format('listing_10_1.m');
%     format('listing_11_1.m');
%     format('listing_11_10.m');
%     format('listing_11_11.m');
%     format('listing_11_12.m');
%     format('listing_11_2.m');
%     format('listing_11_3.m');
%     format('listing_11_4.m');
%     format('listing_11_5.m');
%     format('listing_11_6.m');
%     format('listing_11_7.m');
%     format('listing_11_8.m');
%     format('listing_11_9.m');
%     format('listing_12_1.m');
%     format('listing_12_2.m');
%     format('listing_12_3.m');
%     format('listing_12_4.m');
%     format('listing_12_5.m');
%     format('listing_12_6.m');
%     format('listing_13_1.m');
%     format('listing_13_2.m');
%     format('listing_13_3.m');
%     format('listing_13_4.m');
%     format('listing_13_5.m');
%     format('listing_14_1.m');
%     format('listing_14_2.m');
%     format('listing_14_4.m');
%     format('listing_14_5.m');
%     format('listing_14_6.m');
%     format('listing_14_7.m');
%     format('listing_14_8.m');
%     format('listing_14_9.m');
%     format('listing_15_1.m');
%     format('listing_15_2.m');
%     format('listing_15_3.m');
%     format('listing_15_4.m');
%     format('listing_15_5.m');
%     format('listing_15_6.m');
%     format('listing_15_7.m');
%     format('listing_16_1.m');
%     format('listing_16_2.m');
%     format('listing_16_3.m');
%     format('listing_16_4.m');
%     format('listing_16_5.m');
%     format('listing_17_1.m');
%     format('listing_17_2.m');
%     format('listing_17_3.m');
%     format('listing_17_4.m');
%     format('listing_17_5.m');
%     format('listing_17_6.m');
%     format('makeCD.m');
%     format('makeGraph.m');
%     format('my_cylinder.m');
%     format('Path.m');
%     format('play_steps.m');
%     format('pop.m');
%     format('pqEnq.m');
%     format('push.m');
%     format('qDeq.m');
%     format('qEnq.m');
%     format('toString.m');




function format(scr_name)
% Matlab coloring rules
% Comment dark green
% Number orange
% Key word blue 
%   (break case catch continue else elseif end for function 
%   global if otherwise 
%   return switch try while)
% String magenta	
% 		
% Matlab indention rules
% after function switch add 8
% after function case otherwise for while if else elseif add 4
% at end case otherwise else elseif subtract 4 
% 
%  temp codes within strings:
%   % = char(254)
%   ' = char(253)
%   .* = char(252)
%   ./ = char(251)
%   .^ = char(250)
%   .' = char(249)
%
%   key word indent actions
%   0 - nothing                     break continue global return
%   1 - back one now, fwd one next  case catch else elseif otherwise
%   2 - back one now                end
%   3 - fwd one next                for if try while
%   4 - zero it, fwd one next       function
%   5 - fwd 2 next                  switch

    global keys
    global dbg
    
    keys = struct('cmd', {'break' 'case' 'catch' 'continue' ...
            'else' 'elseif' 'end' 'for'  'function' 'global' ...
            'if' 'otherwise' 'return' 'switch' 'try' 'while'}, ...
                  'val', {  0,      1,     1,       0, ...
              1,      1,      2,    3,     4,       0, ...
              3,      1,       0,       5,      3,     3} );
    delim = [' !"#$&()*+,-/:;<=>?@[\]^`{|}~' char(249) char(250) char(251) char(252)];

    name = ['../listings/' scr_name];
    out_name = [name(1:end-2) '_new.htm'];
    in = fopen(name, 'r');
    if in <= 0
        fprintf('couldn''t open %s for reading\n', name);
        quit 
    end
    out = fopen(out_name, 'w');
    if out <= 0
        fprintf('couldn''t open %s for writing\n', out_name);
        quit 
    end
    fprintf(dbg, '\n\nProcessing file %s\n', name);
    
    done = false;
    indent = 1;
    fprintf(out,'<code><strong>\n');
    while ~done   % still reading good lines
        line = fgetl(in);
        line(line == char(9)) = ' ';
        done = ~ischar(line);
        while(length(line) > 0 && line(1) == ' ')
            line = line(2:end);
        end
        if ~done  % process a line
            % first, process string characters
            % stop looking when you reach a '%' not in a quote
            if length(line) >= 7 && strcmp('B(odds)', line(1:7))
                gotcha = 1;
            end
            quotes = 0;
            stop_at = length(line);
            for ndx = 1:length(line)
                ch = line(ndx);
                if ch == ''''
                    quotes = quotes + 1;
                elseif ch == '%'
                    if rem(quotes,2) == 0
                        stop_at = ndx - 1;
                        break;
                    end
                end
            end
            strdlms = find(line(1:stop_at) == '''');
            % transform operator?
            n = length(strdlms);
            ndx = 1;
            it = '';
%             if(n > 0)
%                 if(rem(n,2) > 0)
%                     fclose(dbg);
%                     error('odd num of quotes')
%                 end
%             end
            quotes = 0;
            while ndx <= stop_at
                ch = line(ndx);
                if ndx == stop_at
                    nxt = 0;
                else
                    nxt = line(ndx+1);
                end
                if(rem(quotes,2) > 0) % if inside quotes, check ''
                    if ch == ''''
                        if nxt == ''''
                            ch = char(253);
                            ndx = ndx + 1;
                        else
                            quotes = quotes + 1;
                        end
                    end
                    if(ch == '%' && rem(quotes,2) == 1)
                        ch = char(254);
                    end
                else
                    % if outside, check .* etc.
                    if ch == '.'
                        if nxt == '*'
                            ch = char(252);
                            ndx = ndx + 1;
                        elseif nxt == '/'
                            ch = char(251);
                            ndx = ndx + 1;
                        elseif nxt == '^'
                            ch = char(250);
                            ndx = ndx + 1;
                        elseif nxt == char(39)
                            ch = char(249);
                            ndx = ndx + 1;
                        end
                    end
                end
                ndx = ndx + 1;
                it = [it ch];
            end
            it = [it line(stop_at+1:end)];
            fprintf(dbg, 'process >%s<\n', it);
            % now, really process it
            dat = '';
            action = 0;
            parens = 0;
            while ~isempty(it)
                if(it(1) == '''')  % a string
                    at = find(it(2:end) == '''');
                    if isempty(at)
                        fclose(dbg);
                        error('missing close quote');
                    end
                    % string 1 - at
                    dat = [dat '<font color="#c000c0">'];
                    for ch = it(1:(at+1))
                        dat = [dat ch];
                    end
                    dat = [dat '</font>'];
                    it = it(at+2:end);
                elseif it(1) == '%' % a comment
                    % process like a comment
                    dat = [dat '<font color="#00A000">'];
                    dat = [dat it(1:end)];
                    dat = [dat '</font>'];
                    it = '';
                else
                    while length(it) > 0 && any(it(1)==delim)
                        if it(1) == '('
                            parens = parens + 1;
                            fprintf(dbg, 'set parens = %d\n', parens);
                        elseif it(1) == ')'
                            parens = parens - 1;
                            fprintf(dbg, 'set parens = %d\n', parens);
                        end
                        dat = [dat it(1)];
                        it = it(2:end);
                    end
                    % process a token
                    [token, it] = strtok(it, delim);
                    if strcmp(token, 'disp') 
                        gotcha = true;
                    end
                    [found, val] = is_key(token);
                    % if this is 'end' inside parens, don't do anything
                    if found 
                        fprintf(dbg, 'see parens = %d\n', parens);
                        if ~strcmp(token, 'end') || parens == 0
                            action = val;
                            dat = [dat '<font color="#0000ff">'];
                            dat = [dat token];
                            dat = [dat '</font>'];
                        else
                            dat = [dat token];
                        end
                    elseif length(token) > 0 && isnumch(token(1))  % number
                        dat = [dat '<font color="#ff8000">'];
                        dat = [dat token '</font>'];
                    else
                        dat = [dat token];
                    end
                    % copy the delims
                    while length(it) > 0 && any(it(1)==delim)
                        if it(1) == '('
                            parens = parens + 1;
                            fprintf(dbg, 'set parens = %d\n', parens);
                        elseif it(1) == ')'
                            parens = parens - 1;
                            fprintf(dbg, 'set parens = %d\n', parens);
                        end
                        dat = [dat it(1)];
                        it = it(2:end);    
                    end
                end    
            end
%   key word indent actions
%   0 - nothing                     break continue global return
%   1 - back one now, fwd one next  case catch else elseif otherwise
%   2 - back one now                end
%   3 - fwd one next                for if try while
%   4 - zero it, fwd one next       function
%   5 - fwd 2 next                  switch
            % do actions for this line
            switch action
                case {1, 2}
                    indent = indent - 1;
                case 4
                    indent = 0;
            end
            for ind = 1:indent
                dat = ['&nbsp;&nbsp;&nbsp;&nbsp;' dat];
            end
            % Do actions for next line
            switch action
                case {1, 3, 4}
                    indent = indent + 1;
                case 5
                    indent = indent + 2;
            end
            dat = [dat '<br>'];
            fprintf(dbg, 'coloring gives >%s<\n', dat);
            dat = replace_stuff(dat);
            fprintf(dbg, 'replace_stuff gives >%s<\n', dat);
            fprintf(out,'%s\n', dat);
        end
     end  % loop and a half exit
    fprintf(out,'</strong></code>\n');
%    end % while there are lines left
    fclose(out);
end  % end of function

function res = isnumch(ch)
    numchars = '0123456789.';
    res = any(ch == numchars);
end

function [found val] = is_key(str)
    global keys
    found = false;
    val = -1;
    if(strcmp(str,'end'))
        gotcha = true;
    end
    for ndx = 1:length(keys)
        cl = {keys.cmd};
        ee = strcmp(str, cl);
        fee = find(ee);
        if length(fee) > 0
            found = true;
            val = keys(fee).val;
            break;
        end
    end
end

function dat = replace_stuff(it)
%   % = char(254)
%   ' = char(253)
%   .* = char(252)
%   ./ = char(251)
%   .^ = char(250)
%   .' = char(249)
    dat = '';
    for ch = it
        if ch == 254  % hidden %
            % put the '%' back
            dat = [dat '%'];
        elseif ch == 253  % hidden "''"
            % put the '''' back
            dat = [dat char(39) char(39)];
        elseif ch == 252  % .*
            % put the .* back
            dat = [dat '.*'];
        elseif ch == 251  % ./
            % put the ./ back
            dat = [dat './'];
        elseif ch == 250  % .^
            % put the .^ back
            dat = [dat '.^'];
        elseif ch == 249  % .'
            % put the .' back
            dat = [dat '.'''];
        else
            dat = [dat ch];
        end
    end
end
