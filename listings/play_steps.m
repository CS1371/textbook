% Listing_14_2  play a tune using half_step count
function main(note)
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
