% Playing with sound
% Exercises with sound
function main
    global Fs
	hear = false;
    % 1. playing back sound
    %       - read "give a damn" speech
    %       - play it
    %       - change amplitude
    %       - change frequency    % 2. slicing sounds
    %       - construct "frankly, Bond, I don't give a damn - beam me up"
    [give, Fs] = audioread('../Text/sp_givdamn2.wav');
    plot(give)
    figure
    fprintf('read and play a sound\n')
    t = (1:length(give)) ./ Fs;
    plot(t, give)
    title('Plot of Rhett speech')
    xlabel('time(sec)')
    ylabel('amplitude')
    give = give./4;
	if hear
		sound(give, Fs)
		pause(length(give) ./ Fs)
	end
    fprintf('play louder - increase amplitude\n')
	if hear
    sound(give.*2, Fs)
    pause(length(give) ./ Fs)
	end
    fprintf('play softer - decrease amplitude\n')
	if hear
    sound(give./2, Fs)
    pause(length(give) ./ Fs) 
	end
    fprintf('play faster - drop half the data\n')
	if hear
    sound(give(1:2:end) , Fs)
    pause(length(give).* 0.5 ./ Fs) 
	end	
    fprintf('play slower - reduce playback frequency\n')
	if hear
    sound(give , Fs/1.5)
    pause(length(give).* 1.5 ./ Fs)
	end
    fprintf('pasting together speech pieces\n')
	give = give .* 4;
    frankly = give(1:5500);
    damn = give(11500:end);
    [bond, bFs] = audioread('../Text/sp_bond.wav');
    bond = bond(1000:6000);
    [beam, bmFs] = audioread('../Text/sp_beam.wav');
    beam = beam.*2;  % make beam louder
    speech = [frankly
        zeros(2000, 1)
        bond
        zeros(2000, 1)
        damn
        zeros(2000, 1)
        beam];
	if hear
    sound(speech, Fs);
    pause(length(speech) ./ Fs)
	end
end
