% listing_08_4
% Reading structure data
clear; clc
    it = readStruct('../beams.xlsx')

function data = readStruct(filename)
    % read a spreadsheet and produce a
    % structure array:
    % name - the second column value
    % pos - columns 3 and 4 in a vector
    % connect - cell array with the remaining
    % data on the row
    [~,~,raw] = xlsread(filename);
    [rows cols] = size(raw);
    % ignore the first row and column
    out = 1;
    for row = 2:rows
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
