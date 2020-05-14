%% make file
%
% Script to build the website with helper function findToConvert()
% 
% Build folder is created, and relative stylesheets, images, and audio
% files are copied over into the correct folder. 
% The index_template and preface are read in order to replace the top and
% side nav objects with the corresponding code.
% Each chapter is read in order to replace the top and side nav objects,
% listings, exercises, templates, and other code that needs to be inserted
% into the html. For all .mlx files, these are turned into separate .html
% files and placed in the build folder.
%
%% 

% Set up build folder
clear; clc;
contents = dir();
if any(strcmp({contents.name}, 'build'))
    rmdir build s;
end
mkdir build;
cd build
mkdir html
cd html
mkdir styles
cd ..
mkdir Images
mkdir listings
mkdir exercises
mkdir audio
mkdir book_templates
cd ..
copyfile html\styles build\html\styles;
copyfile Images build\Images;
copyfile audio build\audio;
cd matlab_tools

% Make nav objects
make_nav_object;

% Print nav bar in index.html
file = fileread('index_template.html');
newnavobj = strrep(navobj, 'href="', 'href="build\html\');
newtopnav = strrep(topnav, 'src="', 'src="build\Images\');
file = strrep(file, '#nav_obj#', newnavobj);
file = strrep(file, '#top_nav#', newtopnav);
fh = fopen('index.html', 'w');
fprintf(fh, '%s', file);
fclose(fh);

cd html
st = dir('*.htm');
chapters = {st.name};

% Modify and copy preface to build folder
preface = chapters{contains(chapters,'Preface')};
file = fileread(preface);
file = strrep(file, '#nav_obj#', navobj);
file = strrep(file, '#top_nav#', topnav);
cd ..\build\html
fh = fopen(preface, 'w');
fprintf(fh, '%s', file);
fclose(fh);
cd ..\..\html

% Modify and copy individual chapters to build folder
chapters = chapters(1:17);
for i = 1:17
    chapter = chapters{i};
    file = fileread(chapter);
    cd ..
    % Add nav bar
    file = strrep(file, '#nav_obj#', navobj);
    file = strrep(file, '#top_nav#', topnav);
    
    % Replace listings
    inds = strfind(file, '#listing_');
    cd listings\livelistings
    for j = 1:length(inds)
        inds = strfind(file, '#listing_');
        [info, ~] = strtok(file(inds(1)+1:end), '#');
        name = sprintf('%s_live.mlx', info);
        file = findToConvert(file, info, name, 'listings');
    end
    cd ..\..
    
    % Replace exercises
    inds = strfind(file, '#exercise_');
    cd exercises
    for j = 1:length(inds)
        inds = strfind(file, '#exercise_');
        [info, ~] = strtok(file(inds(1)+1:end), '#');
        name = sprintf('%s.mlx', info);
        file = findToConvert(file, info, name, 'exercises');
    end
    cd ..
        
    % Replace templates
    inds = strfind(file, '#template_');
    cd book_templates
    for j = 1:length(inds)
        inds = strfind(file, '#template_');
        [info, ~] = strtok(file(inds(1)+1:end), '#');
        name = sprintf('%s.mlx', info);
        file = findToConvert(file, info, name, 'book_templates');
    end
    cd ..
    
    % Replace any others (not listings, exercises, templates)
    inds = strfind(file, '#alt_');
    for j = 1:length(inds)
        inds = strfind(file, '#alt_');
        [info, ~] = strtok(file(inds(1)+1:end), '#');
        [folderName, name] = strtok(file(inds(1)+1:end), '/');
        folderName = folderName(5:end);
        name(1) = [];
        mkdir(sprintf('%s', 'build\', folderName))
        cd(folderName);
        [name, ~] = strtok(name, '#');
        name = sprintf('%s.mlx', name);
        file = findToConvert(file, info, name, folderName);
        cd ..
    end
    
    cd build\html
    fh = fopen(sprintf('%s.htm', chapter(1:end-4)), 'w');
    fprintf(fh, '%s', file);
    fclose(fh);
    cd ..\..\html
end
cd ..    

function file = findToConvert(file, info, name, type)
    toReplace = sprintf('#%s#', info);
    %matlab.internal.liveeditor.executeAndSave(which(name))
    newname = sprintf('%shtml.html', name(1:end-4));
    if strcmp(type, 'listings')
        copyfile(name, '..\..\build\listings');
        cd ..\..\build\listings
    else
        copyfile(name, sprintf('%s', '..\build\', type));
        cd(sprintf('%s', '..\build\', type));
    end
    matlab.internal.liveeditor.openAndConvert(which(name), newname);
    delete(which(name));
    listing = fileread(newname);
    listing = strrep(listing, ': nowrap;', ': normal;');
    listing = strrep(listing, ': pre;', ': normal;');
    listing = strrep(listing, ': pre-wrap;', ': normal;');
    fh_listing = fopen(which(newname), 'w');
    fprintf(fh_listing, '%s', listing);
    fclose(fh_listing);
    file = strrep(file, toReplace, sprintf('<iframe src="%s%s%s%s"></iframe>', '..\', type, '\', newname));
    if strcmp(type, 'listings')
        cd ..\..\listings\livelistings
    else
        cd(sprintf('%s%s', '..\..\', type));
    end
end

