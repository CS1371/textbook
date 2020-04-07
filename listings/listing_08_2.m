%  listing_08_2
%  Listing a file using tokens
function main
    list_text('../Text/mercy.txt')
end

function list_text(fn);
    fh = fopen( fn, 'r' );
    ln = '';
    while ischar( ln )
% to this point, the function is identical to Listing 8.1
        ln = fgetl( fh ); % use fgetl(...) because strtok doesn't need the end-of-line marker.
        if ischar( ln )
% once we have a line, we will use strtok(...) to strip off one word at a time
            ca = [];
% again, we use a while loop because the number of words on a line vary.
            while ~isempty( ln )
% keep going as long as there are characters on the line
                [tk, ln] = strtok( ln );
% we simplify the logic by putting the rest of the line back in ln
                ca = [ca {tk}];
% save all the tokens in a cell array
            end
% display the cell array
            disp( ca );
        end
    end
    fclose( fh );
end