%% make file
%
% Script to build the website 
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
import matlab.internal.liveeditor.LiveEditorUtilities

% Set up build folder
clear; clc;
start_dir = pwd 
% path is C:\Users\dmsmi\Documents\textbook\
contents = dir();
if any(strcmp({contents.name}, 'build'))
    try
        rmdir build s;
    catch
    end
end
mkdir build;
cd build
% path is C:\Users\dmsmi\Documents\textbook\build
mkdir html
cd html
% path is C:\Users\dmsmi\Documents\textbook\build\html
mkdir styles
cd ..
% path is C:\Users\dmsmi\Documents\textbook\build
mkdir Images
mkdir listings
mkdir exercises
mkdir audio
mkdir book_templates
cd ..
% path is C:\Users\dmsmi\Documents\textbook
copyfile html\styles build\html\styles;
copyfile Images build\Images;
copyfile audio build\audio;
cd matlab_tools
% path is C:\Users\dmsmi\Documents\textbook\matlab_tools

% Make nav objects
dms_make_nav_object;
% path is C:\Users\dmsmi\Documents\textbook

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
% path is C:\Users\dmsmi\Documents\textbook\html
st = dir('*.htm');
chapters = {st.name};

% Modify and copy individual chapters to build folder
% for i = 1:length(chapters)
for i = 1:4
% path is C:\Users\dmsmi\Documents\textbook\html
    chapter = chapters{i};
    fprintf('Process %s\n', chapter);
    in = fopen(chapter, 'r');
    outName = ['..\build\html\' chapter];
    out = fopen(outName, 'w');
    cd ..
% path is C:\Users\dmsmi\Documents\textbook
    line = fgets(in);
    while ischar(line)
        pounds = strfind(line, "#");
        if length(pounds) < 2
            fprintf(out, '%s', line);
        else
            from = 1;
            for at = 1:2:length(pounds)
                to = pounds(at)-1;
                start = pounds(at);
                try
                    stop = pounds(at+1);
                catch
                    pounds
                    at
                end
                tag = line(start:stop);
                fprintf(out, '%s', line(from:to));
                from = stop + 1;
%               Add nav bar
                if strcmp(tag, '#nav_obj#')
                    fprintf(out, '%s', newnavobj);
%               % Add top bar
                elseif strcmp(tag, '#top_nav#')
                    fprintf(out, '%s', newtopnav);
                % Replace a listing
                elseif contains(line, '#listing_') 
                    inds = strfind(line, '#listing_');
                    cd listings\livelistings
                    [info, ~] = strtok(line(inds(1)+1:end), '#');
                    fprintf(out, '%s', line(1:inds(1)));
                    name = sprintf('%s_live.mlx', info);
                    new_plug = findToConvert(info, name, 'listings');
                    fprintf(out, '%s', new_plug); 
                    % path is C:\Users\dmsmi\Documents\textbook\listings\livelistings
                    cd ..\..
                    % path is C:\Users\dmsmi\Documents\textbook
                % Replace an exercise
                elseif contains(line, '#exercise_') 
                    inds = strfind(line, '#exercise_');
                    cd exercises
                    % path is C:\Users\dmsmi\Documents\textbook\exercises
                    [info, ~] = strtok(line(inds(1)+1:end), '#');
                    name = sprintf('%s.mlx', info);
                    new_plug = findToConvert(info, name, 'exercises');
                    fprintf(out, '%s', new_plug); 
                    % path is C:\Users\dmsmi\Documents\textbook\exercises
                    cd ..
                    % path is C:\Users\dmsmi\Documents\textbook\
                % Replace a template
                elseif contains(line, '#template_') 
                    inds = strfind(line, '#');
                    cd book_templates
                    [info, ~] = strtok(line(inds(1)+1:end), '#');
                    name = sprintf('%s.mlx', info);
                    new_plug = findToConvert(info, name, 'book_templates');
                    fprintf(out, '%s', new_plug); 
                    % path is C:\Users\dmsmi\Documents\textbook\book_templates
                    cd ..
                    % path is C:\Users\dmsmi\Documents\textbook\
                % Replace any others (not listings, exercises, templates)
                else 
                    inds = strfind(line, '#alt_');
                    [info, ~] = strtok(line(inds(1)+1:end), '#');
                    [folderName, name] = strtok(file(inds(1)+1:end), '/');
                    folderName = folderName(5:end);
                    name(1) = [];
                    mkdir(sprintf('%s', 'build\', folderName))
                    cd(folderName);
                    [name, ~] = strtok(name, '#');
                    name = sprintf('%s.mlx', name);
                    new_plug = findToConvert(info, name, folderName);
                    fprintf(out, '%s', new_plug); 
                    cd ..
                end
            end
        end
        line = fgets(in);
    end
    fclose(out);
    cd html
% path is C:\Users\dmsmi\Documents\textbook\html
end

function plug = findToConvert(info, name, type)
    toReplace = sprintf('#%s#', info);
    newname = sprintf('%shtml.html', name(1:end-4));
    
    if strcmp(type, 'listings')
        path = sprintf('..\\..\\build\\%s\\', type);
        copyfile(name, path);
        cd(path)
    else
    % path is C:\Users\dmsmi\Documents\textbook\exercises
        path = sprintf('..\\build\\%s\\', type);
    % this path is C:\Users\dmsmi\Documents\textbook\
        copyfile(name, path);
        cd(path)
    end
    try 
        matlab.internal.liveeditor.openAndConvert(which(name), newname);
    catch ME
        ME
        error('error at openAndConvert') ;
    end
    delete(which(name));
    listing = fileread(newname);
    listing = strrep(listing, ': nowrap;', ': normal;');
    listing = strrep(listing, ': pre;', ': normal;');
    listing = strrep(listing, ': pre-wrap;', ': normal;');
    fh_listing = fopen(which(newname), 'w');
    fprintf(fh_listing, '%s', listing);
    fclose(fh_listing);
    plug = sprintf('<iframe src="%s%s%s%s"></iframe>', '..\', type, '\', newname);
    if strcmp(type, 'listings')
        cd ..\..\listings\livelistings
    % path is C:\Users\dmsmi\Documents\textbook\listings\livelistings
    else
        cd(sprintf('%s%s', '..\..\', type));
        % path is C:\Users\dmsmi\Documents\textbook\exercises
    end
end

