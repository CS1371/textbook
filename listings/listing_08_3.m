% listing_08_3
% Script to copy a text file
clear; clc
    copy_text('../mercy.txt','../mercy_copy.txt')

function copy_text(ifn, ofn)
    ih = fopen( ifn, 'r' );
    oh = fopen( ofn, 'w' );
    ln = '';
    while ischar( ln )
        ln = fgets( ih );
        if ischar( ln )
            fprintf( oh, ln );
        end
    end
    fclose( ih );
    fclose( oh );
end
