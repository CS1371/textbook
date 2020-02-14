% Listing 14.2: Building a tune file

% Read the file and set up the parameters
[note, Fs] = wavread( 'instr_piano.wav' );
half = 2^(1/12);
doremi = [1 3; 2 1; 3 3; 1 1; 3 2; 1 2; 3 4; 2 3;
    3 1; 4 1; 4 1; 3 1; 2 1; 4 8; 3 3; 4 1;
    5 3; 3 1; 5 2; 3 2; 5 4; 4 3; 5 1; 6 1;
    6 1; 5 1; 4 1; 6 4 ];

% A vector defining how many half steps it takes to set the frequency of
% notes 1-8.
steps = [0 2 4 5 7 9 11 12];
dt = .2; % The time between notes of length 1 - the beat of the tune
nCt = floor(dt*Fs); % The number of samples to play for one beat of the tune
storeAt = 1; % Begin storing notes at the beginning of the tune

% Insert each note in the song file into the tune file
for index = 1:length(doremi)
    key = doremi(index,1); % Fetches the key number
    pow = steps(key); % Extracts the number of half steps required for this note
    theNote = note(ceil(1:half^pow:end)); % Stretches the original note by this multiplier
    % Compute where the end of the note will be stored
    noteLength = length(theNote);
    noteEnd = storeAt + noteLength - 1;
    tune(storeAt:noteEnd,1) = theNote; % Copies the note into the tune file
    % Advances the storeAt index down the tune file by the beat count
    % multiplied by the beats required for this note
    storeAt = storeAt + doremi(index,2) * nCt; 
end

% Plays the complete tune and save it as a .wav file.
sound(tune, Fs)
wavwrite(tune, Fs, 'dohAdeer.wav' )
