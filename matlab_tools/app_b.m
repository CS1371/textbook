clear
clc
top_rows = {'NUL','SOH','STX','ETX','EOT','ENQ','ACK','BEL', ...
            'BS','HT','LF','VT','FF','CR','SO','SI' ...
            'DLE','DC1','DC2','DC3','DC4','NAK','SYN','ETB' ...
            'CAN','EM','SUB','ESC','FS','GS','RS','US'};
out = fopen('../html/App_B_table.htm','w');
% hook up with CSS
fprintf(out, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">\n');
fprintf(out, '<html>\n');
fprintf(out, '<head>\n');
fprintf(out, '    <title>App B Table</title>\n');
fprintf(out, '    <link rel="stylesheet" href="styles/styles.css" />\n');
fprintf(out, '    <script async src="./javascript/index.js"></script>\n');
fprintf(out, '</head>\n');
fprintf(out, '<body bgcolor="#ffffc0">\n');

fprintf(out, '<table>\n');
% header row
fprintf(out, '<tr>\n');
fprintf(out, '<th></th>');
for col = 0:15
    fprintf(out, '<th>%s</th>', sprintf('%d', col));
end
fprintf(out, '</tr>\n');
%s rows 0 and 16
fprintf(out, '<tr>\n');
fprintf(out, '<td>%s</td>', sprintf('%d', 0));
for col = 1:16
    % cols 1 - 16
    fprintf(out, '<td>%s</td>', top_rows{col});
end
fprintf(out, '</tr>\n<tr>\n');
fprintf(out, '<td>%s</td>', sprintf('%d', 16));
for col = 17:32
    % cols 17 - 32
    fprintf(out, '<td>%s</td>', top_rows{col});
end
for col = 32:255
    if rem(col,16) == 0  % first column
        fprintf(out, '</tr>\n<tr>\n');
        fprintf(out, '<td>%s</td>', sprintf('%d', col));
    end
    % all columns
    if col == 127 || col == 255
        fprintf(out, '<td>DEL</td>');
    else
        fprintf(out, '<td>%s</td>', char(col));
    end
end
fprintf(out, '\n</tr>\n');

fprintf(out, '</table>\n');
fprintf(out, '</body>\n');
fprintf(out, '</html>\n');

