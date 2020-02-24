%  FFT of a sine wave
function main
    % fundamental relationships
    %       N samples
    %       Fs - sampling frequency
    %       dt = 1/Fs
    %       Tmax = N * dt
    %       df = 1/Tmax
    %       Fmax = N * df
    %           really mirrored about Fmax/2
    %           usually plot many points less
    %
    %   Start with a 3 sec sine wave at Middle C, 261.6 Hz
    Fs = 44100
    Tmax = 3
    N = Fs .* Tmax
    mid_C = 261.6 * 2 * pi;
    t = linspace(0, Tmax, N);
    note = sin(mid_C .* t);
    sound(note, Fs)
    pause(length(note) ./ Fs)
    plot(t, note)
    Y = fft(note);
    f = linspace(0, Fs, N);
    ns = N / 10;
    plot(f(1:ns), real(Y(1:ns)))
    %
    figure
    [tpt, Fs] = audioread('../Text/instr_tpt.wav');
    N = length(tpt);
    sound(tpt, Fs)
    tmax = N/Fs;
    pause(tmax)
    Y = fft(tpt);
    fmax = Fs;
    ns = 20000;
    f = linspace(0, fmax, N);
    plot(f(1:ns), abs(Y(1:ns)));
    grid on
    pause(1)
    figure
    plot3(f(1:ns), real(Y(1:ns)), imag(Y(1:ns)))
    xlabel('Frequency');
    ylabel('Real Part');
    zlabel('Imaginary Part');
    grid on
    [note Fs] = audioread('../Text/trainwhistle.wav');
    N = length(note);
end
