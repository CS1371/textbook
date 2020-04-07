% listing_08_1
% Script to list a text file
function main
    list_text('../Text/mercy.txt'); % Specify the file and call our function to list it.
end

function list_text(fn)
    fh = fopen( fn, 'r' ); % open the file for reading and return the file handle.
    % we will use a while loop since we do not know how many lines are in the file
    ln = ''; % initialize the while loop
    while ischar( ln ) % as long as there is text remaining the line will be of type char
    % when the EOF is read, fgets/l(...) returns -1, not of type char
        ln = fgetl( fh );
        if ischar( ln ) % don't process ln unless it's type char
            fprintf( '%s\n', ln ); % use fprintf(...) to print the line
        end
    end
    fclose( fh ); % close the file
end
