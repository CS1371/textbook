% Listing 14.5: Script to plot eight-instrument spectra

% Sets up the subplots configuration
rows = 4; cols = 2

% Each pair of lines makes the subplots of one instrument.
subplot(rows, cols, 1)
inst( 'sax' , 'Saxophone' );
subplot(rows, cols, 2)
inst( 'flute' , 'Flute' );
subplot(rows, cols, 3)
inst( 'tbone' , 'Trombone' );
subplot(rows, cols, 4)
inst( 'piano' , 'Piano' );
subplot(rows, cols, 5)
inst( 'tpt' , 'Trumpet' );
subplot(rows, cols, 6)
inst( 'mutetpt' , 'Muted Trumpet' );
subplot(rows, cols, 7)
inst( 'violin' , 'Violin' );
subplot(rows, cols, 8)
inst( 'cello' , 'Cello' );