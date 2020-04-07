% listing_08_3
% Script to copy a text file
function main
    copy_text('../Text/mercy.txt','../Text/mercy_copy.txt')
end

function copy_text(ifn, ofn)
    ih = fopen( ifn, 'r' );
    oh = fopen( ofn, 'w' );
    ln = '';
    while ischar( ln )
        ln = fgetl( ih );
        if ischar( ln )
            fprintf( oh, '%s\n', ln );
% The '\n' on the end of the format control string inserts whatever line-end-marker your computer uses
        end
    end
    fclose( ih );
    fclose( oh );
end