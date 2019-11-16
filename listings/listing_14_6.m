% Plotting the spectrum of one instrument
function main
    pause(1)
    figure
    [piano Fs] = audioread('..\instr_piano.wav');
    frq = 261
    duration = length(piano)/Fs;   % sec
    
    t = linspace(0, duration, Fs * duration);
    totalLength = Fs * duration;
    w = 2 * pi * frq;
    Y = fft(piano);
    N = 10000;
    Y = Y(1:N);
    f = 1:N;
    df = Fs/length(piano);
    f = f .* df;
    plot(f, abs(Y))
    val = max(abs(Y));
    thr = 150;
    ndx = 1;
    while val > thr;
        [val where] = max(abs(Y));
        C(ndx) = Y(where);
        loc(ndx) = where;
        fr = where - 50;
        to = where + 50;
        if fr < 1, fr = 1, end
        if to > N, to = N, end
        Y(where-50:where+50) = 0;
        ndx = ndx + 1;
    end
    % sort the coefficients
    [junk ndx] = sort(loc);
    coeff = C(ndx);
    note = zeros(1, Fs * duration);
    pianoLength = length(piano);
    for ndx = 1:length(coeff)
        note = note + real(coeff(ndx)) .* cos(ndx * w * t);
        note = note + imag(coeff(ndx)) .* sin(ndx * w * t);
    end
    % scale it to +/- 1
    amp = max(abs(note));
    note = note / amp;
    % check fft of note (wrong!)
    figure
    Y = fft(note);
    Y = Y(1:N);
    plot(f, abs(Y))
    figure
    plot(piano)
    % calc the amp shape of the piano
    % chop into pieces (20 samples per sec)
    size = Fs/30;
    place = size+1;
    ndx = 1;
    while place < pianoLength - size
        val(ndx) = max(piano((place-size):(place+size)));
        loc(ndx) = place;
        ndx = ndx + 1;
        place = place + size*2;
    end
    hold on
    plot(loc, val, 'r*')
    % curve fit the points
    cf = polyfit(loc, val, 8);
    ampmod = polyval(cf, 1:totalLength);
    plot(1:totalLength, ampmod, 'c')
    note = note .* ampmod;
    sound(note, Fs)
    tmax = length(note) / Fs;
    pause(tmax)
    sound(piano, Fs)
	pause(length(piano) ./ Fs)
end
