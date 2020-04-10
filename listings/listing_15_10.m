% Plot the sound's time history in a new figure window
figure
plot(snd)
hold on

% Arbitrarily choose a time sample increment to achieve a small but
% representative set of amplitude samples
incr = 1000;
at = 1;
samples = [];
tm = [];

% A loop to compute and store the amplitude samples and the corresponding
% time indices. Each step calculates the maximum amplitude during its time
% window and saves it with the window location.
while at < (N - incr)
    val = max(snd(at:at+incr-1));
    samples = [samples val];
    tm = [tm at+incr/2];
    at = at + incr;
end

% Plots the sample locations
plot(tm, samples,'r*')

% Compute and plot the polynomial fit to the amplitudes using an
% eighth-order fit
coeff = polyfit(tm, samples, 8);
samp = polyval(coeff, tm);
plot(tm, samp, 'c')

% Modify the synthesized piano sound by multiplying the amplitude profile
% determined in this script 
amult = polyval(coeff, 1:length(f));
f = f .* amult;
sf = f ./ max(f);
sound(sf, Fs)