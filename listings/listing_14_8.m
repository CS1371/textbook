% Synthesizing a piano
function main
    global N
    global note
    global Fs
    global tempo
    global song
    global total_time
    Fs = 44100;
    note = synthetic_piano;
    N = length(note);
    halfStep = 2 .^ (1/12);
    treble = {'G4' 3
        'A4' 1
        'G4' 3
        'A4' 1
        'B4' 3
        'D5' 1
        'E5' 3
        'D5' 1
        %
        'G5' 3
        'FS5' 1
        'A5' 3
        'G5' 1
        'FS5' 3
        'A5' 1
        'G5' 3
        'E5' 1
        %
        'D5' 3
        'D5' 1
        'E5' 3
        'D5' 1
        'G5' 3
        'E5' 1
        'D5' 3
        'B4' 1
        %
        'A4' 16
        %
        'G4' 3
        'A4' 1
        'G4' 3
        'A4' 1
        'B4' 3
        'D5' 1
        'E5' 3
        'D5' 1
        %
        'G5' 3
        'FS5' 1
        'A5' 3
        'G5' 1
        'FS5' 3
        'A5' 1
        'G5' 3
        'E5' 1
        %
        'D5' 3
        'D5' 1
        'G5' 3
        'G4' 1
        'A4' 4
        'D5' 4
        %
        'G4' 16
        };
    bass = { 'G2' 4
        'B2' 4
        'G3' 4
        'B3' 4
        %
        'C3' 4
        'E3' 4
        'G3' 4
        'C4' 4
        %
        'G2' 4
        'B2' 4
        'G3' 4
        'B3' 4
        %
        'D3' 4
        'G3' 4
        'FS3' 4
        'E3' 4
        %
        'G2' 4
        'B2' 4
        'G3' 4
        'B3' 4
        %
        'C3' 4
        'E3' 4
        'G3' 4
        'C4' 4
        %
        'B2' 4
        'E3' 2
        'EF3' 2
        'D3' 8
        %
        'G2' 3
        'D3' 1
        'B3' 3
        'D3' 1
        'G2' 4 };
    tempo = 500 / 60;  % number of beats in a second
    beats = 0;         % total beats
    for ndx = 1:length(treble)
        beats = beats + treble{ndx,2};
    end
    total_time = beats ./ tempo;
    Nt = total_time .* Fs;
    Nt = Nt + N + N;
    song = zeros(Nt,2);
    tic
    play_score(treble, 1);
    play_score(bass, 2);
    sound(song, Fs)
    pause(total_time)
    audiowrite('humoresque_1.wav', song, Fs)
    fprintf('playing time %0.3f\n', toc)
end
function play_score(notes, col)
    global N
    global note
    global Fs
    global tempo
    global total_time
    global song
    
    at = 1;
    for ndx = 1:length(notes)
        name = notes{ndx, 1};
        dur = notes{ndx, 2};
        %   translate 'G4' to nt
        [mult, muted] = getPitch(name);
        %    - number of half steps above middle C
        %     mult = halfStep .^ nt;
        sampler = floor(linspace(1, N, N / mult));
        play = note(sampler);
        %         sound(play, Fs)
        %       copy play at at
        if at + length(play) > length(song)
            play = play(1:(length(song) - at - 1));
        end
        % limit length of note to note duration
        nn = round(Fs .* dur ./ tempo);
        if length(play) > nn
            play = play(1:nn);
        end
        try
            song(at : (at + length(play) - 1), col) = ...
                song(at : (at + length(play) - 1), col) + play;
        catch
            ouch = true;
        end
        at = at + nn;
    end
end
function note = synthetic_piano
    global Fs
    % create a piano note playing middle C
    coeff =[ -2.7871 2.8145
        -3.1836 0.2835
        -0.7267 1.2517
        -0.4538 0.4381
        -0.7132 0.2829
        0.6205 0.2548
        -0.5155 0.4718
        0.2322 0.3237
        0.1586 0.1278
        -0.1321 0.0467]
    coeff = coeff .* 1000;
    shape = [   1.102058e-37
        -4.114411e-32
        6.294645e-27
        -5.028251e-22
        2.195125e-17
        -4.919492e-13
        4.704579e-09
        -3.395830e-05
        9.247657e-01 ];
    
    duration = 2;
    note = zeros(1, Fs * duration);
    frq = 261;
    t = linspace(0, duration, Fs * duration);
    totalLength = Fs * duration;
    w = 2 * pi * frq;
    for ndx = 1:length(coeff)
        note = note + coeff(ndx, 1) .* cos(ndx * w * t);
        note = note + coeff(ndx, 2) .* sin(ndx * w * t);
    end
    % scale it to +/- 1
    amp = max(abs(note));
    note = note / amp;
    ampmod = polyval(shape, 1:totalLength);
    note = note .* ampmod;
    note = note';
    sound(note, Fs)
    pause(length(note)./Fs)
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
