% listing_07_3
% Constructor for a CD structure
clear; clc
    it = makeCD('classical','Yo Yo Ma','Bach',2017, 5, 19.95)

function ans = makeCD(gn, ar, ti, yr, st, pr)
    % integrate CD data into a structure
    ans.genre = gn ;
    ans.artist = ar ;
    ans.title = ti;
    ans.year = yr;
    ans.stars = st;
    ans.price = pr;
end
