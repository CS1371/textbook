% listing_08_4
% Reading structure data
function main
    adj = readStruct('beams.xlsx')
end

function data = readStruct(filename)
    % read a spreadsheet and produce a structure array:
    % - index - the first column values
    % - name - the name of each node
    % - pos - columns 3 and 4 in a vector
    % - connect - cell array with the remaining data on the row
    raw = readcell(filename);             % Read the spreadsheet.
    [rows cols] = size(raw);              % Find the size of the raw data
    out = 1;                              % index of the structure array returned
    for row = 2:rows                      % Iterate across the rows except the first row
        str.index = raw{row,1};           % The first column is the numerical index
        str.name = raw{row,2};            % The second column is the node name
        str.pos = [raw{row,3} raw{row,4}];% Columns 3 and 4 are the numerical position of the node [we don't need this]
        cni = 1;                % Index of the connecting nodes
        conn = {};                % Collect the connected nodes here
        for col = 5:cols                % Iterate across the remaining columns
            item = raw{row, col};        % Fetch each item
            if ~ischar(item)        % If it is not a string,
                break;        % ... stop processing the row
            end
            conn{cni} = item;        % Otherwise, save the connected node
            cni = cni + 1;        % ... and bump the index of connections
        end
        str.connect = conn;% Store the cell array of connections
        data(out) = str;% Store this structure
        out = out + 1;% ... and increment the structure index
    end
end