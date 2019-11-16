% Building a tune file_name
function main
    global note
    global Fs
	pause(1)
	figure
    [Y f] = compute('../instr_violin.wav');
    subplot(3, 1, 1)
    ne = round(length(f) / 4);
    plot(f(1:ne), Y(1:ne))
    xlabel('frequency(Hz)');
    ylabel('sound energy (relative)');
    title('frequency spectrum of violin')
    [Y f] = compute('../instr_tpt.wav');
    subplot(3, 1, 2)
    plot(f(1:end/4), Y(1:end/4))
    xlabel('frequency(Hz)');
    ylabel('sound energy (relative)');
    title('frequency spectrum of trumpet')
    [Y f] = compute('../trainwhistle.wav');
    subplot(3, 1, 3)
    n = round(length(f)/10);
    plot(f(1:n), Y(1:n))
    xlabel('frequency(Hz)');
    ylabel('sound energy (relative)');
    title('frequency spectrum of whistle')
	play_steps(note)
end
function [Y, f] = compute( name )
    global note
    global Fs   
    [note Fs] = audioread(name);
    sound(note, Fs)
    N = round(length(note) / 2);
    Y = abs(fft(note)) / N;
    Y = Y(1:N);
    f = (1:N) * Fs / (2*N);
    pause(length(note)./Fs)
end
% Listing_14_2  play a tune using half_step count
function play_steps(note)
	global Fs
    half_note = 2.^(1/12);
    N = length(note)/10;
    fprintf('play a tune using half_step count for pitch\n')
    notes = [   4  2
        2  1
        0  2
        0  1
        0  2
        2  1
        4  2
        4  1
        4  1
        2  1
        0  1
        2  1
        4  1
        2  1
        0  2
        -1  1
        0  4];
    for ndx = 1:length(notes)
        nt = notes(ndx, 1);
        dur = notes(ndx, 2);
        mult = half_note .^ nt;
        sampler = floor(linspace(1, N, N / mult));
        sound(note(sampler), Fs)
        pause(0.2*dur)
    end
end
