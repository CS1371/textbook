% listing_07_5
% Building a structure array using a custom constructor
clear; clc
    % extracts from http://www.cduniverse.com/	12/30/04
    cds(1) = makeCD('Blues', 'Clapton, Eric', ...
        'Sessions For Robert J', 2004, 2, 18.95 );
    cds(2) = makeCD('Classical', ...
        'Bocelli, Andrea', 'Andrea', 2004, 4.6, 14.89 );
    cds(3) = makeCD( 'Country', 'Twain, Shania', ...
        'Greatest Hits', 2004, 3.9, 13.49 );

    cds