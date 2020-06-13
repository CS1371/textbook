%% one at a time make file
%
% Script to build the website with helper function findToConvert()
% 
% Build folder is created, and relative stylesheets, images, and audio
% files19 are copied over into the correct folder. 
% The index_template and preface are read in order to replace the top and
% side nav objects with the corresponding code.
% Each chapter is read in order to replace the top and side nav objects,
% listings, exercises, templates, and other code that needs to be inserted
% into the html. For all .mlx files, these are turned into separate .html
% files and placed in the build folder.
%
%% 
function one_at_a_time
    clc
    
    choice = 0;
    while choice ~= 99
        fprintf('00_Initialize\n')
        fprintf('01_Introduction.htm\n')
        fprintf('02_Basics.htm\n')
        fprintf('03_Functions.htm\n')
        fprintf('04_Vectors.htm\n')
        fprintf('05_Execution.htm\n')
        fprintf('06_Strings.htm\n')
        fprintf('07_Structures.htm\n')
        fprintf('08_File_I_O.htm\n')
        fprintf('09_Recursion.htm\n')
        fprintf('10_Problem_Solving.htm\n')
        fprintf('11_Plotting.htm\n')
        fprintf('12_Matrices.htm\n')
        fprintf('13_Images.htm\n')
        fprintf('14_Sounds.htm\n')
        fprintf('15_Numerical_Methods.htm\n')
        fprintf('16_Sorting.htm\n')
        fprintf('17_Graphs.htm\n')
        fprintf('18_Appendix_A.htm\n');
        fprintf('19_Appendix_B.htm\n');
        fprintf('20_Appendix_C.htm\n');
        fprintf('21_Appendix_D.htm\n');
        fprintf('22_Preface.htm\n')
        fprintf('23_text_index.htm\n')
        fprintf('99_Quit\n');
        choice = input('Choose your action: ');    
        if choice ~= 99
            doit(choice)
        end
    end
end

function doit(choice)
    cd html
    st = dir('*.htm');
    chapters = {st.name};
    cd  ..
    switch choice
        case 0   % initialize the build folders         
            % Set up build folder
            contents = dir();
            if any(strcmp({contents.name}, 'build'))
                try
                    % remove the whole build structure
                    rmdir build s;
                catch
                end
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
            save nav.mat navobj topnav 
            newnavobj = strrep(navobj, 'href="', 'href="build\html\');
            newtopnav = strrep(topnav, 'src="', 'src="build\Images\');
            file = strrep(file, '#nav_obj#', newnavobj);
            file = strrep(file, '#top_nav#', newtopnav);
            fh = fopen('index.html', 'w');
            fprintf(fh, '%s', file);
            fclose(fh);
        case {18 19 20 21 22 23}
            % Modify and copy odd files to build folder
            if ~isfile('nav.mat')
                error('build not initialized')
            end 
            load nav.mat
            cd html
            name = '';
            switch choice
                case 18
                    name = chapters{contains(chapters,'Appendix_A')};
                case 19
                    name = chapters{contains(chapters,'Appendix_B')};
                case 20
                    name = chapters{contains(chapters,'Appendix_C')};
                case 21
                    name = chapters{contains(chapters,'Appendix_D')};
                case 22
                    name = chapters{contains(chapters,'Preface')};
                case 23
                    name = chapters{contains(chapters,'index')};
            end
            fprintf('Process %s\n', name);
            file = fileread(name);
            file = strrep(file, '#nav_obj#', navobj);
            file = strrep(file, '#top_nav#', topnav);
            cd ..\build\html
            fh = fopen(name, 'w');
            fprintf(fh, '%s', file);
            fclose(fh);
            cd ..\..
        otherwise
            % Modify and copy individual chapters to build folder
            if ~isfile('nav.mat')
                error('build not initialized')
            end 
            load 'nav.mat'
            cd html
            chapters = chapters(1:23);
            chapter = chapters{choice};
            fprintf('Process %s\n', chapter);
            
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
            try 
                cd exercises
                for j = 1:length(inds)
                    inds = strfind(file, '#exercise_');
                    [info, ~] = strtok(file(inds(1)+1:end), '#');
                    name = sprintf('%s.mlx', info);
                    file = findToConvert(file, info, name, 'exercises');
                end
            catch ME
%                 ME
%                 error('Error at findToConvert')
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
            clear file
            cd ..\..
    end
end


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
    file = strrep(file, toReplace, sprintf('<iframe src="%s%s%s%s"></iframe>', '..\', type, '\', newname));
    if strcmp(type, 'listings')
        cd ..\..\listings\livelistings
    else
        cd(sprintf('%s%s', '..\..\', type));
    end
end

