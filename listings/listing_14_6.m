% Script to plot eight-instrument spectra
function main
    [y Fs] = audioread('../Text/instr_tpt.wav');
    sound(y, Fs)
    N = length(y);
    pause(N./Fs)
    plot(y)
    xlabel('time (sec)')
    ylabel('sound amplitude')
    figure
    Y = fft(y) / (N/2);
    f = (1:N) * Fs / N;
    plot3(f(1:end/4), real(Y(1:end/4)), imag(Y(1:end/4)))
    grid on
    xlabel('frequency')
    ylabel('real part')
    zlabel('imag part')
    absY = abs(Y(1:end/4));
    af = f(1:end/4);
    figure
    plot(af, absY)
    % find the peaks
    nFreq = 40;
    for ndx = 1:nFreq
        [junk where] = max(absY);
        frq = where * Fs / N;
        rl = real(Y(where));
        im = imag(Y(where));
        absY(where-50:where+50) = 0;
        coef(ndx,1) = frq/1000;
        coef(ndx,2) = rl;
        coef(ndx,3) = im;
    end
    % now, reconstruct the sound, one spike at a time
    [~, order] = sort(coef(:,1));
    for ndx = 1:3
        coef(:,ndx) = coef(order,ndx);
    end
    nSynth = 3*Fs;
    synth = zeros(nSynth,1);
    t = (0:nSynth - 1) ./ Fs;
    snd = zeros(nSynth, 1);
    for ndx = 1:length(coef)
        w = coef(ndx,1) .* 2000 .* pi;
        note = coef(ndx,2) .* cos(w.*t) + coef(ndx,3) .* sin(w*t);
        snd = snd + note';
    end
    mx = max(abs(snd));
    sound(snd./mx, Fs)
    pause(t(end));
    coef
end
