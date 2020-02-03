%  listing_08_2
%  Listing a file using tokens
function main
    list_text('../Text/mercy.txt')
end

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
