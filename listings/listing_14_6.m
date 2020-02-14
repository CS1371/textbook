% Listing 14.6: Synthesizing a Piano

% Read the sound file and compute the representative parameters.
[snd Fs] = wavread('instr_piano.wav');
N = length(snd)
sound(snd, Fs)
tMax = N / Fs
dt = 1 / Fs

% Perform the FFT and compute its representative parameters
% and Ns, the number of samples we are interested in.
Y = fft(snd);
Ns = N/4;
fMax = Fs/4;
df = fMax / Ns;

%Compute a vector of the frequencies and extract the real
% and imaginary coefficients.
f = ((1:Ns) - 1) * df;
rl = real(Y(1:Ns));
im = imag(Y(1:Ns));

% Plot the coefficient absolute values (see Figure 14.11 ).
plot(f, abs(Y(1:Ns)))
xlabel('frequency (Hz)')
ylabel('real amplitude')
zlabel('imag amplitude')
amps = abs(Y(1:end/2)); % Stores the absolute values of the coefficients.

Nc = 25;
for ndx = 1:Nc
    % Extract the 25 largest coefficients by first finding the
    % maximum absolute coefficient
    [junk where] = max(amps);
    % Save the frequency and complex amplitudes
    C(ndx).freq = where;
    C(ndx).coeff = Y(where);
    % Remove that peak from the amplitude vector
    amps(where-25:where+25) = 0;
end

% Sort the complex coefficients in frequency order.
frq = [C.freq];
[frq order] = sort(frq);
sortedStr = C(order);

% Set up the time trace parameters and storage.
Nt = 25;
t = (1:2*Fs) * dt;
f = zeros(1, length(t));

% Build the sound file composed of the real coefficients
% times the cosine of the frequency and the imaginary coefficients times
% the sine of the frequency.
for ndx = 1:Nt
    w = frq(ndx) * df * 2 * pi;
    ct = cos(w*t);
    st = sin(w*t);
    Cf = sortedStr(ndx).coeff;
    f = f + real(Cf) * ct + imag(Cf) * st;
end

% Scale and play the sound
% Amplitude shaping goes here
sf = f ./ max(f);
sound(sf, Fs)