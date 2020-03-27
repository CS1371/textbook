cd html
files = dir('*.htm');

% Initialize navbar and chapter list
navobj = '<nav class="nav sidenav nav-scroll navbar-dark bg-dark">\n';
navobj = [navobj '<ul class="navbar-nav">\n']; 

for i = [1 2 9:17]
    % Find chapter information
    filename = files(i).name;
    text = fileread(filename);
    [chp_num,chp_name] = strtok(filename,'_');
    chp_name(chp_name == '_') = ' ';
    chp_num = str2num(chp_num);
    chp_name = chp_name(2:end-4);
    tree = htmlTree(text);
    chp_section_tree = findElement(tree,'div.chp-section');
    chp_section_names = getAttribute(chp_section_tree, 'data-sect-name');
    chp_section_num = getAttribute(chp_section_tree, 'data-sect-num');
    
    % Add overall chapter to navbar
    navobj = [navobj '<li class="nav-item">\n'];
    % Add reference for overall chapter 
    reference = sprintf(['<a class="nav-link" href="%s#%d">%d %s&nbsp;&nbsp;'], ...
        filename,chp_num, chp_num,chp_name);
    dropdown = sprintf('<span class="dropdown-toggle" data-target="#sec_%d" data-toggle="collapse"></span>',chp_num);
    navobj = [navobj reference dropdown '</a>\n']; 
    
    % Add chapter sections
    navobj = [navobj sprintf('<ul class="list-unstyled collapse" id="sec_%d">\n', chp_num)];  
    
    for i = 1:length(chp_section_tree)
        % Find if has subsections 
        chp_sub_tree = findElement(chp_section_tree(i), 'div.chp-subsection');
               
        % Get id for section
        attr = getAttribute(findElement(chp_section_tree(i), 'H2'), 'id');
        
        % Print list item for section
            navobj = [navobj '<li class="nav-item secnav">\n'];
        
        % Implement another dropdown menu
        if ~isempty(chp_sub_tree)             
            % Print reference
            reference = sprintf('<a class="nav-link" href="%s#%s">%d.%s %s&nbsp;&nbsp;', ...
                filename, attr, chp_num, chp_section_num(i), chp_section_names(i));
            dropdown = sprintf('<span class="dropdown-toggle" data-target="#sub_%d_%d" data-toggle="collapse"></span>',chp_num, i);
            navobj = [navobj reference dropdown '</a>\n'];
            
            % Create next layer of navbar for subsections
            % Get subsection data
            chp_sub_names = getAttribute(chp_sub_tree, 'data-sub-name');
            chp_sub_num = getAttribute(chp_sub_tree, 'data-sub-num');

            % Make new div for subsections
            navobj = [navobj sprintf('<ul class="list-unstyled collapse" id="sub_%d_%d">\n',chp_num,i)];

            for j = 1:length(chp_sub_tree) 
                % Make list element
                navobj = [navobj '<li class="nav-item subnav">\n'];
                % Make reference 
                attr = getAttribute(findElement(chp_sub_tree(j), 'H3'), 'id');
                reference = sprintf('<a class="nav-link" href="%s#%s">%d.%s.%s %s</a>',filename,attr, ...
                    chp_num, chp_section_num(i), chp_sub_num(j), chp_sub_names(j));
                navobj = [navobj reference '\n'];
                navobj = [navobj '</li>\n'];
            end
            
            % Close list for subsection
            navobj = [navobj '</ul>\n'];
        else
            navobj = [navobj '<li class="nav-item secnav">\n'];
            reference = sprintf(['<a class="nav-link" href="%s#%s">%d.%s %s</a>'], ...
                filename, attr, chp_num, chp_section_num(i), chp_section_names(i));
            navobj = [navobj reference '\n'];
        end
        % Close list elem for sections
        navobj = [navobj '</li>\n'];
    end
    
    % Close list for sections
    navobj = [navobj '</ul>\n'];
    
    % Close list elem for chapter
    navobj = [navobj '</li>\n'];
    
end

% Close chapter list and overall nav
navobj = [navobj '</ul>\n'];
navobj = [navobj '</nav>\n'];

cd ..

