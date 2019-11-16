% Integrating rocket velocity
function main
    pause(1)
    figure
    v =[ 0.0 15.1 25.1 13.7 22.2 41.7 ...
        39.8 54.8 57.6 62.6 61.6 63.9 69.6 ...
        76.2 86.7 101.2 99.8 112.2 111.0 ...
        116.8 122.6 127.7 143.4 131.3 143.0 ...
        144.0 162.7 167.8 180.3 177.6 172.6 ...
        166.6 173.1 173.3 176.0 178.5 ...
        196.5 213.0 223.6 235.9 244.2 244.5 ...
        259.4 271.4 270.5 294.5 297.6 ...
        308.7 310.5 326.6 344.1 342.0 358.2 362.7 ];
    lv = length(v);
    dt = 0.2;
    t = (0:lv-1) * dt;
    h = dt .* cumsum(v);
    plot(t, v)
    grid on, hold on
    plot(t, h/5,'k--')
    legend({'velocity', 'altitude/5' })
    title('velocity and altitude of a rocket')
    xlabel('time (sec)'); ylabel('v (m/s), h(m/5)')
    fprintf('cumsum height: %g\n', h(end) );
    ht = dt .* cumtrapz(v);
    fprintf('trapezoidal height: %g\n', ht(end));
end
