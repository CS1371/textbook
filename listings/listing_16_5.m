% Updated world data analysis

% Wraps the script in a pseudo-function to allow the helper
% functions to reside in the same file.
function main
    % Reads in the world data
    worldData = buildData('../Text/World_data.xls');
    % Selects the number of countries to represent
    n = 20;
    % Calls the function that will return the indices of the n best
    % countries.
    bestn = findBestn(worldData, n);
    % Print the list of country names in reverse order (the best first).
    fprintf('best %d countries are:\n', n)
    for best = bestn(end:-1:1)
        fprintf('%s\n', worldData(best).name)
    end
end

% Show an updated version of the original function to return
% the indices of the n best countries.
function bestn = findBestn(worldData, n)
    % find the indices of the n best countries
    % according to the criterion in the function fold
    % we first map world data to add the field growth
    
    % Map the worldData structure array, adding to each a
    % field called growth that contains the criterion specified in the fold
    % function.
    for ndx = 1:length(worldData)
        cntry = worldData(ndx);
        worldData(ndx).growth = fold(cntry);
    end
    % Extract and sort the values of growth for each country.
    values = [worldData.growth];
    [junk order] = sort(values);
    % Filter these to keep the best 10. Returns the last n countries that 
    % will have the highest growth values.
    bestn = order(end-n+1:end);
end

% The fold function unchanged from Chapter 10.
function ans = fold(st)
    % s1 is the rate of growth of population
    pop = st.pop(~isnan(st.pop));
    yr = st.year(~isnan(st.pop));
    s1 = slope(yr, pop)/mean(pop);
    % s2 is the rate of growth of the GDP
    gdp = st.gdp(~isnan(st.gdp));
    yr = st.year(~isnan(st.gdp));
    s2 = slope(yr, gdp)/mean(gdp);
    % Measure of merit is how much faster
    % the gdp grows than the population
    ans = s2 - s1;
end

% The modified slope function from Chapter 10 .
function sl = slope(x, y)
    % Estimate the slope of a curve
    if length(x) == 0 || x(end) == x(1)
        error('bad data')
    else
        % Use polyfit to compute an accurate slope and return it to the 
        % calling function.
        coef = polyfit(x, y, 1);
        sl = coef(1);
    end
end

function worldData = buildData(name)
    % read the spreadsheet into a data array
    % and a text cell array
    [data txt] = xlsread(name);
    country = ' '; % force the first data row
    % to change the country
    cntry_index = 0;
    % Traverse the data and cell arrays producing
    % an array of structures,
    % one for each country
    for row = 1:length(data)
        % Because the text data in txt contains
        % the header row of the spreadsheet,
        % the data at a given row belongs to the country
        % whose name is at txt{row+1}.
        % if the country name changes,
        % begin a new structure.
        if ~strcmp(txt{row+1}, country)
            col = 1;
            country = txt{row+1};
            cntry_index = cntry_index + 1;
            cntry.year = 1;
            cntry.pop = 1;
            cntry.gdp = 1;
        end
        cntry.name = country;
        cntry.year(col) = data(row, 1);
        cntry.pop(col) = data(row, 2);
        cntry.gdp(col) = data(row, 5);
        col = col + 1;
        worldData(cntry_index) = cntry;
    end
end
