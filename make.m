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
make_nav_object;
cd html
st = dir('*.htm');
chapters = {st.name};
chapters = chapters(1:17);

for i = [1 2 5:17]
    chapter = chapters{i};
    file = fileread(chapter);
    cd ..
    % Add nav bar
    file = strrep(file, '#nav_obj#', navobj);
    
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
    listing = strrep(listing, 'nowrap', 'normal');
    listing = strrep(listing, 'pre', 'normal');
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