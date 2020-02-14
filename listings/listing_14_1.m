% Listing 14.1: Play a scale by shrinking the noise

% Read the note and set the step multipliers.
[note, Fs] = wavread( 'instr_piano.wav' );
half = 2^(1/12);
whole = half^2;
% Play eight notes of a major scale.
for index = 1:8
    % Plays the note. This implementation uses a blocking sound(...)
    % function. If your system does not block, you will need to insert
    % pause(0.3) here to wait for most of the note to complete.
    sound(note, Fs);
    
    % Choose the appropriate frequency multiplying factor.
    if (index == 3) || (index == 7)
        mult = half;
    else
        mult = whole;
    end
    
    % Shrinks the note by the chosen factor.
    note = note(ceil(1:mult:end));
end