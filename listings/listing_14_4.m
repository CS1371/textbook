% Listing 14.4: Plotting the spectrum of one instrument

% Shows a function consuming two strings: the name of the instrument and
% the title of the plot.
function inst(name, ttl)
    % plot the spectrum of the instrument with
    % the given name, with the given plot title

    % Read the file and set up plot parameters
    [x, Fs] = wavread([ 'instr_' name '.wav' ]);
    N = length(x);
    dt = 1/Fs; % sampling period (sec)
    t = (1:N) * dt; % time array for plotting

    % Perform the FFT and computes the absolute value.
    Y = abs(fft(x)); % perform the transform

    % Scale the plot to be a percentage of the maximum energy at any frequency.
    mx = max(Y);
    Y = Y * 100 / mx;

    % Set up and plot the first 10% of the spectrum.
    df = 1 / t(end) ; % the frequency interval
    fmax = df * N / 2 ;
    f = (1:N) * 2 * fmax / N;
    up = floor(N/10);
    plot(f(1:up), Y(1:up) );
    title(ttl)
    xlabel( 'Frequency (Hz)' )
    ylabel( 'Energy' )
end