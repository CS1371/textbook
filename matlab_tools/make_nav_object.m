%% make_nav_object
%
% Script to build both top and side nav objects for the website. Side
% navigation bar is made by going through each chapter, pulling out
% individual sections, and creating the html code.
%
% Side navigation guidelines from html:
% - Each section is contained within a div with class chp-section and data
% sect-name and sect-num. 
% - Each subsection is contained with a div with class chp-subsection and
% data sub-name and sub-num.
%
%%

cd ..\html
files = dir('*.htm');

% Make topnav object
topnav = sprintf('%s', ['<nav class="navbar navbar-expand-lg fixed-top '...
    'top-nav navbar-light bg-light"><a class="navbar-brand" href="#">'...
    '<img src="../Images/1371.png" width="30" height="30" class="d-inline-block align-top" alt="">'...
    '&nbspEngineering Computation Using MATLAB</a></nav>']);

% Initialize navbar and chapter list
navobj = '<nav class="nav sidenav nav-scroll navbar-dark bg-dark">';
navobj = [navobj '<ul class="navbar-nav">'];

% Add index and preface
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="..\..\index.html">Home</a></li>'];
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="Preface.htm">Preface</a></li>'];

for i = 1:17
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
    navobj = [navobj '<li class="nav-item">'];
    navobj = [navobj '<div class="nav-link">'];
    % Add reference for overall chapter 
    reference = sprintf(['<a href="%s#%d">%d %s&nbsp;&nbsp;</a>'], ...
        filename,chp_num, chp_num,chp_name);
    dropdown = sprintf('<span class="dropdown-toggle" data-target="#sec_%d" data-toggle="collapse"></span>',chp_num);
    navobj = [navobj reference dropdown '</div>']; 
    
    % Add chapter sections
    navobj = [navobj sprintf('<ul class="list-unstyled collapse" id="sec_%d">', chp_num)];  
    
    for i = 1:length(chp_section_tree)
        % Find if has subsections 
        chp_sub_tree = findElement(chp_section_tree(i), 'div.chp-subsection');
               
        % Get id for section
        attr = getAttribute(findElement(chp_section_tree(i), 'H2'), 'id');
        
        % Print list item for section
            navobj = [navobj '<li class="nav-item secnav">'];
        
        % Implement another dropdown menu
        if ~isempty(chp_sub_tree)             
            % Print reference
            navobj = [navobj '<div class="nav-link">'];
            reference = sprintf('<a href="%s#%s">%d.%s %s&nbsp;&nbsp;</a>', ...
                filename, attr, chp_num, chp_section_num(i), chp_section_names(i));
            dropdown = sprintf('<span class="dropdown-toggle" data-target="#sub_%d_%d" data-toggle="collapse"></span>',chp_num, i);
            navobj = [navobj reference dropdown '</div>'];
            
            % Create next layer of navbar for subsections
            % Get subsection data
            chp_sub_names = getAttribute(chp_sub_tree, 'data-sub-name');
            chp_sub_num = getAttribute(chp_sub_tree, 'data-sub-num');

            % Make new div for subsections
            navobj = [navobj sprintf('<ul class="list-unstyled collapse" id="sub_%d_%d">',chp_num,i)];

            for j = 1:length(chp_sub_tree) 
                % Make list element
                navobj = [navobj '<li class="nav-item subnav">'];
                navobj = [navobj '<div class="nav-link">'];
                % Make reference 
                attr = getAttribute(findElement(chp_sub_tree(j), 'H3'), 'id');
                reference = sprintf('<a href="%s#%s">%d.%s.%s %s</a>',filename,attr, ...
                    chp_num, chp_section_num(i), chp_sub_num(j), chp_sub_names(j));
                navobj = [navobj reference '</div>'];
                navobj = [navobj '</li>'];
            end
            
            % Close list for subsection
            navobj = [navobj '</ul>'];
        else
            navobj = [navobj '<li class="nav-item secnav">'];
            navobj = [navobj '<div class="nav-link">'];
            reference = sprintf('<a href="%s#%s">%d.%s %s</a>', ...
                filename, attr, chp_num, chp_section_num(i), chp_section_names(i));
            navobj = [navobj reference '</div>'];
        end
        % Close list elem for sections
        navobj = [navobj '</li>'];
    end
    
    % Close list for sections
    navobj = [navobj '</ul>'];
    
    % Close list elem for chapter
    navobj = [navobj '</li>'];
    
end
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="Appendix_A.htm">Appendix A</a></li>'];
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="Appendix_B.htm">Appendix B</a></li>'];
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="Appendix_C.htm">Appendix C</a></li>'];
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="Appendix_D.htm">Appendix D</a></li>'];
navobj = [navobj '<li class="nav-item">'];
navobj = [navobj '<a class="nav-link" href="text_index.htm">Index</a></li>'];

% Close chapter list and overall nav
navobj = [navobj '</ul>'];
navobj = [navobj '</nav>'];

cd ..