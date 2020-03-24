% listing_07_5
% Building a structure array using a custom constructor
function main
% Data from www.cduniverse.com on 1/21/06
    cds( 1) = makeCD( 'Punk', 'Get Behind Me Satan', 'White Stripes', 2005, 3.7, 14.59 );
    cds( 2) = makeCD( 'Punk', 'Complete Discography', 'Minor Threat', 1990, 4.4, 10.39 );
    cds( 3) = makeCD( 'Punk', 'Fresh Fruit For Rotting Vegetables', 'Dead Kennedys', ...
            1980, 5,  14.29 );
    cds( 4) = makeCD( 'Punk', 'Take This To Your Grave', 'Fall Out Boy', 2003, 4.4, 9.75 );
    cds( 5) = makeCD( 'Punk', 'Stories And Alibis', 'Matchbook Romance', 2003, 4.4, 9.75 );
    cds( 6) = makeCD( 'Heavy metal', 'Rosenrot', 'Rammstein', 2005, 4.1, 17.79 );
    cds( 7) = makeCD( 'Heavy metal', 'Elements Of Persuasion', 'James Labrie', ...
            2005, 4.4, 14.29 );
    cds( 8) = makeCD( 'Heavy metal', 'Second Life Syndrome', 'Riverside', 2005, 4.1, 13.89 );
    cds( 9) = makeCD( 'Heavy metal', 'Still Life', 'Opeth', 2000, 4.8, 10.29 );
    cds(10) = makeCD( 'Heavy metal', 'Rough Cutt Wants You', 'Rough Cutt', 2005, 4.7, 13.29 );
    cds(11) = makeCD( 'Rap', 'Unpredictable', 'Jamie Foxx', 2005, 4.5,16.19 );
    cds(12) = makeCD( 'Rap', 'The Breakthrough', 'Blige, Mary J', 2005, 4.4, 13.65 );
    cds(13) = makeCD( 'Rap', 'Curtain Call: The Hits', 'Eminem', 2005, 4.5, 12.69 );
    cds(14) = makeCD( 'Rap', '13 Blue Magic Lane', 'Blue Magic', 2005, 5, 9.09 );
    cds(15) = makeCD( 'Rap', 'Duets: The Final Chapter', 'Notorious ', 2005, 4.1, 15.05 );
    cds(16) = makeCD( 'Blues', 'Bronx In Blue', 'Dion', 2006, 4.3, 9.50 );
    cds(17) = makeCD( 'Blues', 'Super Session', 'Bloomfield, Mike et al', 1968, 4.5, 9.75 );
    cds(18) = makeCD( 'Blues', 'It Ain''t Easy', 'Baldry, Long John', 2005, 5, 15.69 );
    cds(19) = makeCD( 'Blues', 'Mourning In The Morning', 'Otis Rush', 1969, 1, 9.09 );
    cds(20) = makeCD( 'Blues', 'Had To Cry Today', 'Joe Bonamassa', 2004, 4.3, 14.29 );
    cds(21) = makeCD( 'Classical', 'Tchaikovsky: Suite no 3', ' Jurowski et al', 2006, 5, 13.99 );
    cds(22) = makeCD( 'Classical', 'Most Relaxing Classical Album in the World...Ever!',  'Most Relaxing Classical Album In World Ever', 1999, 4, 15.79 );
    cds(23) = makeCD( 'Classical', 'Phantom Of The Opera', 'Hybrid', 2004, 5, 15.79 );
    cds(24) = makeCD( 'Classical', 'Mozart: Wind Concertos', ...
          'Concertgebouw Chamber Orchestra', 2006, 1, 13.99 );
    cds(25) = makeCD( 'Classical', 'Wicked', 'Original Cast', 2003, 4.8, 15.49 );
    cds(26) = makeCD( 'Oldies', 'Bronx In Blue', 'Dion', 2006, 4.3, 9.50 );
    cds(27) = makeCD( 'Oldies', 'Gold', 'Righteous Brothers', 2005, 1, 13.99 );
    cds(28) = makeCD( 'Oldies', 'Greatest Hits', 'Ricky Nelson', 2005, 5, 15.79 );
    cds(29) = makeCD( 'Oldies', 'Black & White Night', 'Roy Orbison', 1989, 4.8, 11.29 );
    cds(30) = makeCD( 'Oldies', 'Retrospective', 'Animals', 2004, 4.3, 14.49 );
    cds(31) = makeCD( 'Oldies', 'Very Best Of Frankie Valli & The Four Seasons', 'Frankie Valli', 2002, 5, 15.69 );

    cds
end