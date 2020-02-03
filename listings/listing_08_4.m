% listing_08_4
% Reading structure data
function main
    adj = readStruct('beams.xlsx')
end

function data = readStruct(filename)
    % read a spreadsheet and produce a
    % structure array:
    % index - the first column value
    % name - the second column value
    % pos - columns 3 and 4 in a vector
    % connect - cell array with the remaining
    % data on the row
    [~,~,raw] = xlsread(filename);
    [rows cols] = size(raw);
    out = 1;
    for row = 2:rows
        str.index = raw{row,1};
        str.name = raw{row,2};
        str.pos = [raw{row,3} raw{row,4}];
        cni = 1;
        conn = {};
        for col = 5:cols
            item = raw{row, col};
            if ~ischar(item)
                break;
            end
            conn{cni} = item;
            cni = cni + 1;
        end
        str.connect = conn;
        data(out) = str;
        out = out + 1;
    end
end
