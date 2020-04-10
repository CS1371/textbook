% Set up the time domain signal
dt = 1/400 % sampling period (sec)
pts = 10000 % number of points
f = 8 % frequency
t = (1:pts) * dt; % time array for plotting
x = sin(2*pi*f*t);

% Plot the front part of the time trace
subplot(3, 1, 1)
plot(t(1:end/25), x(1:end/25));
title( 'Time Domain Sine Wave' )
ylabel( 'Amplitude' )
xlabel( 'Time (Sec)' )

Y = fft(x); % perform the transform

% Set up the frequency plots
df = 1 / t(end) % the frequency interval
fmax = df * pts / 2
f = (1:pts) * 2 * fmax / pts;
% frequencies for plotting

% Plot the spectrum real part.
subplot(3, 1, 2)
plot(f, real(Y))
title( 'Real Part' )
xlabel( 'Frequency (Hz)' )
ylabel( 'Energy' )

% Plot the spectrum imaginary part.
subplot(3, 1, 3)
plot(f, imag(Y))
title( 'Imaginary Part' )
xlabel( 'Frequency (Hz)' )
ylabel( 'Energy' )