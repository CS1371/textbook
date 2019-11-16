% Playing the piano
% Playing the piano
function main
    [note Fs] = audioread('../instr_piano.wav');
    N = length(note);
    half_note = 2.^(1/12);
    fprintf('middle C on the piano\n')
    sound(note, Fs);
    pause(length(note) ./ Fs)
    fprintf('octave higher by doubling the playback frequency\n')
    sound(note, Fs*2);
    pause(length(note) ./ (2*Fs))
    fprintf('octave lower by stretching the sound vector\n')
    sound(note(round(1:0.5:end)), Fs);
    pause(length(note) ./ (0.5*Fs))
    fprintf('middle C on the piano\n')
    sound(note, Fs)
    seconds = 0.5; % length(note) / Fs
    pause(seconds)
    mult = half_note;
    fprintf('play an octave of black and white notes\n')
    for count = 1:12
        sound(note, Fs*mult)
        pause(seconds)
        mult = mult * half_note;
    end
    fprintf('play C major scale by changing frequency\n')
    gaps = [2 2 1 2 2 2 1];
    mult = 1;
    sound(note, Fs)
    pause(seconds)
    for count = 1:length(gaps)
        times = gaps(count);
        mult = mult * (half_note .^ times);
        sound(note, Fs*mult)
        pause(seconds)
    end
    fprintf('play C major scale by shrinking the sound vector\n')
    mult = 1;
    sound(note, Fs)
    pause(seconds)
    for count = 1:length(gaps)
        times = gaps(count);
        mult = mult * (half_note .^ times);
        ndx = round(linspace(1,N,N/mult));
        sound(note(ndx), Fs)
        pause(seconds)
    end
	play_steps(note)
    run('../ramblinWreck')   % fetch the score
    fprintf('play a tune using music notation for pitch\n')
    solo = play_part(soloPart,'organ', 180);
    t = 0.75 * length(solo) ./ Fs;
    sound(solo, Fs)
    pause(t)
    fprintf('assemble orchestra parts\n')
    solo = play_part(soloPart, 'tpt', 180);
    solomax = max(abs(solo));
    NSolo = length(solo);
    soprano = play_part(sopranoPart, 'piano', 180);
    sopmax = max(abs(soprano));
    NSop = length(soprano);
    alto1 = play_part(alto1Part, 'piano', 180);
    alto1max = max(abs(alto1));
    NA1 = length(alto1);
    alto2 = play_part(alto2Part, 'piano', 180);
    alto2max = max(abs(alto2));
    NA2 = length(alto2);
    tenor = play_part(tenorPart, 'organ', 180);
    tenormax = max(abs(tenor));
    NT = length(tenor);
    bass = play_part(bassPart, 'tbone', 180);
    bassmax = max(abs(bass));
    NB = length(bass);
    RSize = max([NSop NA1 NA2 NT NB]);
    right = zeros(RSize, 1);
    LSize = max([NSolo, NB]);
    left = zeros(LSize, 1);
    NRight = 5;
    NLeft = 8;
    right(1:NSop) = right(1:NSop) + soprano ./ NRight;
    right(1:NA1) = right(1:NA1) + alto1 ./ NRight;
    right(1:NA2) = right(1:NA2) + alto2 ./ NRight;
    right(1:NT) = right(1:NT) + tenor ./ NRight;
    right(1:NB) = right(1:NB) + bass ./ NRight;
    left(1:NSolo) = left(1:NSolo) + solo * 1.5 ./ NLeft;
    left(1:NB) = left(1:NB) + bass * 3 ./ NLeft;
    wreck(1:RSize,1) = right;
    wreck(1:LSize,2) = left;
    keep = (right ~= 0) | (left ~= 0);
	wreck = wreck(keep);
    sound(wreck, Fs)
    pause(length(wreck)./Fs)
    audiowrite('new_wreck.wav', wreck, Fs)
end
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
function part = play_part( score, instr, rate)
    global Fs;
    fname = ['../instr_' instr '.wav'];
    [note Fs] = audioread(fname);
    note = [note; zeros(200000,1)];
    lngth = overall(score);
    Ns = length(note);
    maxSize = Ns + Fs * lngth * 60 / rate;
    part = zeros(maxSize,1);
    dt = 60/rate;
    where = 1;
    samples = Fs * dt;
    for ndx = 1:length(score)
        name = score{ndx, 1};
        dur = score{ndx, 2};
        pitch = getPitch(name);
        num = samples * dur;
        if ~strcmp(name, 'R0')
            index = ceil(linspace(1, Ns, Ns/pitch));
            notes = note(index(1:num));
            part(where:(where+num-1)) = part(where:(where+num-1))  + notes;
        end
        where = where + num;
    end
end
function sum = overall(score)
    sum = 0;
    N = length(score);
    for it = 1:N
        sum = sum + score{it,2};
    end
end
function [pitch, muted] = getPitch(note)
% Get the pitch of a note in ascii form
    half = 2.^(1/12);
    muted = false;
    switch note(1:end-1)
        case {'C'}
            power = 0;
        case {'R'}
            power = 0;
            muted = true;
        case {'CS' 'DF'}
            power = 1;
        case 'D'
            power = 2;
        case {'DS' 'EF'}
            power = 3;        
        case 'E'
            power = 4;
        case 'F'
            power = 5;
        case {'FS' 'GF'}
            power = 6;
        case 'G'
            power = 7;
        case {'GS' 'AF'}
            power = 8;
        case 'A'
            power = 9;
        case {'AS' 'BF'}
            power = 10;
        case 'B'
            power = 11;
        otherwise
            error(['bad note value: ' note])
    end
    let = note(end) - '0';
    diff = let - 4;
    power = power + 12 * diff;
    pitch = half .^ power;
end
