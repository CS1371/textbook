% Country analysis
function main
    % build the country array
    worldData = buildData('../World_data.xls');
    best = findBest(worldData);
    fprintf('best country is %s\n', ...
        worldData(best).name)
end
function besti = findBest(worldData)
    % find the index of the best country
    % according to the criterion in the function
    % fold
    best = fold(worldData(1));
    besti = 1;
    for ndx = 2:length(worldData)
        cntry = worldData(ndx);
        tryThis = fold(cntry);
        if tryThis > best
            best = tryThis;
            besti = ndx
        end
    end
end
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
function sl = slope(x, y)
    % Estimate the slope of a curve
    if length(x) == 0 || x(end) == x(1)
        error('bad data')
    else
        sl = (y(end) - y(1))/(x(end) - x(1));
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
