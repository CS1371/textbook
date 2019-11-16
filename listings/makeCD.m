% Listing_07_4  Constructor for a CD structure
function ans = makeCD(gn, ar, ti, yr, st, pr)
    % integrate CD data into a structure
    ans.genre = gn ;
    ans.artist = ar ;
    ans.title = ti;
    ans.year = yr;
    ans.stars = st;
    ans.price = pr;
end
