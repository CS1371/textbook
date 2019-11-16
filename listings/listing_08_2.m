%  listing_08_2
%  Listing a file using tokens
clear; clc
    list_text('../mercy.txt')

function list_text(fn);
    fh = fopen( fn, 'r' );
    ln = '';
    while ischar( ln )
        ln = fgetl( fh );
        if ischar( ln )
            ca = [];
            while ~isempty( ln )
                [tk, ln] = strtok( ln );
                ca = [ca {tk}];
            end
            disp( ca );
        end
    end
    fclose( fh );
end
