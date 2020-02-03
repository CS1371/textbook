% listing_08_1
% Script to list a text file
function main
    list_text('../Text/mercy.txt');
end

function list_text(fn);
    fh = fopen( fn, 'r' );
    ln = '';
    while ischar( ln )
        ln = fgetl( fh );
        if ischar( ln )
            fprintf( '%s\n', ln );
        end
    end
    fclose( fh );
end
