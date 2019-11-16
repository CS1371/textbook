% Synthesizing a piano
function main
    global Fs
    global music
    trumpet = [        0.2620    0.0396   -0.0148
        0.5239    0.0104    0.0796
        0.7854    0.1424    0.0327
        1.0210    0.0001   -0.0013
        1.0474   -0.0628    0.1309
        1.2844   -0.0018    0.0005
        1.3089   -0.0311    0.1919
        1.5464    0.0010    0.0017
        1.5709   -0.1093   -0.0044
        1.8079    0.0011   -0.0011
        1.8324   -0.0336    0.1103
        2.0699   -0.0007    0.0011
        2.0944   -0.0646   -0.0306
        2.3314    0.0010    0.0005
        2.3559   -0.0111    0.0609
        2.5924   -0.0002   -0.0010
        2.6173    0.0458    0.0104
        2.8549   -0.0001    0.0011
        2.8793   -0.0256    0.0544
        3.1408    0.0171    0.0257
        3.3783   -0.0012    0.0002
        3.4028   -0.0098    0.0389
        3.6643    0.0116    0.0076
        3.9263   -0.0076    0.0061
        4.1878   -0.0032    0.0044
        4.4497   -0.0038   -0.0050
        4.7112   -0.0057    0.0022
        4.9732   -0.0025   -0.0042
        5.2347   -0.0066    0.0013
        5.4962   -0.0007    0.0051
        5.7582   -0.0055    0.0002
        6.0197   -0.0020    0.0039
        6.2816   -0.0041   -0.0010
        6.5431   -0.0020    0.0028
        6.8051   -0.0027   -0.0012
        7.0666   -0.0018    0.0019
        7.3286   -0.0017   -0.0012
        7.5901   -0.0017    0.0010
        7.8520   -0.0008   -0.0012
        8.1135   -0.0014    0.0001];
    america = { 'G4' 1      %  O
        'G4' 1.5    % beautiful
        'E4' 0.5
        'E4' 1
        'G4' 1      % for
        'G4' 1.5    % spacious
        'D4' 0.5
        'D4' 1      % skies
        'E4' 1      % for
        'F4' 1      % amber
        'G4' 1
        'A4' 1      % waves
        'B4' 1      % of
        'G4' 3      % grain
        'G4' 1      % for
        'G4' 1.5    % purple
        'E4' 0.5
        'E4' 1      % mountains'
        'G4' 1
        'G4' 1.5    % majesties
        'D4' 0.5
        'D4' 1
        'D5' 1      % above
        'CS5' 1
        'D5' 1      % the
        'E5' 1      % fruited
        'A4' 1
        'D5' 3      % plain
        'G4' 1      % America,
        'E5' 1.5
        'E5' 0.5
        'D5' 1
        'C5' 1      % America,
        'C5' 1.5
        'B4' 0.5
        'B4' 1
        'C5' 1      % God
        'D5' 1      % send
        'B4' 1      % His
        'A4' 1      % grace
        'G4' 1      % on
        'C5' 3      % thee
        'C5' 1      % and
        'C5' 1.5    % crown
        'A4' 0.5      % thy
        'A4' 1      % good
        'C5' 1      % with
        'C5' 1.5    % brotherhood
        'G4' 0.5
        'G4' 1
        'G4' 1      % from
        'A4' 1      % sea
        'C5' 1      % to
        'G4' 1      % shining
        'D5' 1
        'C5' 8 };   % sea
    
    play(america, trumpet, 150)
    
end
function play( score, instr, rate)
    global Fs;
    global music;
    Fs = 44100;
    tmax = 3;   % sec
    N = tmax * Fs;
    t = (1:N) /Fs;
    % play middle C with a synthetic instrument
    freq = 261;
    w = 2 * pi * freq;
    note = zeros(1,N);
    for ndx = 1:length(instr)
        w = instr(ndx, 1) * 2000 * pi;
        rl = instr(ndx, 2);
        im = instr(ndx, 3);
        note = note + rl * cos(w * t);
        note = note + im * sin(w * t);
    end
    note = [note'; zeros(200000,1)];
    Ns = length(note);
    dt = 60/rate;
    where = 1;
    samples = Fs * dt;
    lngth = overall(score);
    maxSize = Ns + Fs * lngth * 60 / rate;
    music = zeros(maxSize,1);
    for ndx = 1:length(score)
        name = score{ndx, 1};
        dur = score{ndx, 2};
        pitch = getPitch(name);
        num = samples * dur;
        index = ceil(linspace(1, Ns, Ns/pitch));
        notes = note(index(1:num));
        music(where:(where+num-1)) = music(where:(where+num-1))  + notes;
        where = where + num;
    end
	music = music(music ~= 0);
    sound(music, Fs);
	pause(length(music) ./ Fs)
    audiowrite([inputname(1) '_' inputname(2) '.wav'], music, Fs )
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
function sum = overall(score)
    sum = 0;
    N = length(score);
    for it = 1:N
        sum = sum + score{it,2};
    end
end
