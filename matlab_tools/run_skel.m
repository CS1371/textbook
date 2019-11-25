clear
clc
fill_skeleton(7, '../html/07_Structures.htm', '../Text/Ch_07.txt')

function fill_skeleton(chapter, skeleton_name, text_name)
% tool to import an empty chapter and a text file and create a full html
% file ready for detailed editing
% inputs: chapter number
%         skeleton_name - header and footer file
%         text_name - chapter text file
% example:  fill_skeleton(7, '../html/07_Structures.htm',
%                            '../Text/Ch_07.txt')
% Relevant contents are:
%   skeleton:
% <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
% <html>
% <head>
%     <title>07_Structures</title>
%     <link rel="stylesheet" href="styles/styles.css" />
%     <script async src="./javascript/index.js"></script>
% </head>
% <body bgcolor="#ffffff">
% <h1 align="center">Chapter 7: Cell Arrays and Structures</h1>
% 
% <table align="center">
% 	<tbody>
% 		<tr>
% 			<td><a href="06_Strings.htm">previous</a></td>
% 			<td><a href="Contents.htm">home</a></td>
% 			<td><a href="08_File_I_O.htm">next</a></td>
% 		</tr>
% 	</tbody>
% </table>
% </body>
% </html>
%
% Text:
% CHAPTER	7
% 
% Cell Arrays and Structures
% 
% 
% 7.1  Concept: Collecting Dissimilar  Objects
% 7.2   Cell Arrays
% 7.2.1  Creating Cell Arrays
% 7.2.2  Accessing Cell Arrays
% 7.2.3  Using Cell Arrays
% 7.2.4  Processing Cell Arrays
% 7.3  Structures
% ... etc
% 
% Chapter Objectives
% 
% This chapter discusses the nature, implementation, and behavior of collections that may contain data items of any class, size, or shape. We will deal with two different heterogeneous storage mechanisms:
% 
% ?	Those accessed by index (cell arrays)
% 
% ?	Those accessed by field name (structures)
% 
% In addition, we will consider collecting structures into arrays of structures.
% 
% Introduction
% 
% This chapter covers data collections that are more general and flexible than the arrays we have considered so far. Heterogeneous collections may contain objects of any type, rather than just numbers. Consequently, none of the collective operations defined for numerical arrays can be applied to cell arrays or structures. To perform most operations on their contents, the items must be extracted one at a time and replaced if necessary. We will consider three different mechanisms for building heterogeneous collections:
% you access components of a cell array with a numerical index; you acc components of a structure with a symbolic field name; and you access c of a structure array by way of a numerical index to reach a specific stru then a symbolic field name.
% 
% 7.1	Concept: Collecting Dissimilar Objects
% 
% Heterogeneous collections permit objects of different data types to be grouped in a collection. They allow data abstraction to apply to a much broader range of content. However, the fact that the contents of these collections may be of any data type severely restricts the operations that can be performed on the collections as a whole. Whereas a significant number of arithmetic and logical operations can be performed on whole number arrays, algorithms that process heterogeneous collections almost always deal with the data contents one item at a time.
% 
% 7.2	Cell Arrays
% 
% Cell arrays, as the name suggests, have the general form of arrays and can be indexed numerically as arrays. However, each element of a cell array should be considered as a container in which one data object of any class can be stored.1 They can be treated as arrays of containers for the purpose of concatenation and slicing. However, if you wish to access or modify the contents of the containers, the cells must be accessed individually.
% 1 --- Java programmers might recognize a cell array as an array of Objects.
% 
% 7.2.1	Creating Cell Arrays
% 
% Cell arrays may be constructed in the following ways:
% ?	By assigning values individually to a variable indexed with braces:
% 
% >> A{1} = 42 A = [42]
% ?	By assigning containers individually to a variable indexed with brackets:
% 
% >> B[1] = {[4 6]}; B =
% [1x2 double]
% ?	By concatenating cell contents using braces {. . .}:
%
% Output
% 
% <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
% <html>
% <head>
%     <title>07_Structures</title>
%     <link rel="stylesheet" href="styles/styles.css" />
%     <script async src="./javascript/index.js"></script>
% </head>
% <body bgcolor="#ffffff">
% <h1 align="center">Chapter 7: Cell Arrays and Structures</h1>
% 
% <table align="center">
% 	<tbody>
% 		<tr>
% 			<td><a href="06_Strings.htm">previous</a></td>
% 			<td><a href="Contents.htm">home</a></td>
% 			<td><a href="08_File_I_O.htm">next</a></td>
% 		</tr>
% 	</tbody>
% </table>
% 
% <ul>
% 	<li><a href="#7_1">7.1  Concept: Collecting Dissimilar Objects</a>
% 	<li><a href="#7_2">7.2   Cell Arrays</a>
% 	<ul>
% 		<li><a href="#7_2_1">7.2.1  Creating Cell Arrays</a></li>
% 		<li><a href="#7_2_2">7.2.2  Accessing Cell Arrays</a></li>
% 		<li><a href="#7_2_3">7.2.3  Using Cell Arrays</a></li>
% 		<li><a href="#7_2_4">7.2.4  Processing Cell Arrays</a></li>
% 	</ul>
% 	</li>
% 	<li><a href="#7_3">7.3  Structures</a>
% 	<ul>
% </ul>
% 
% 
% ... etc
% 
% <h2>Chapter Objectives</h2>
% <text>
% <p>Introduction</p>
% <text>
% <h2><a name="7_1">7.1  Concept: Collecting Dissimilar Objects</a></h2> 
% <text>
% <h2><a name="7_2">7.2   Cell Arrays</a></h2> 
% <text>
% <h3><a name=""#7_2_1">7.2.1  Creating Cell Arrays</a></h3>
% <text>
% <h3><a name=""#7_2_2">7.2.2  Accessing Cell Arrays</a></h3>
% <text>
% <h3><a name=""#7_2_3">7.2.3  Using Cell Arrays</a></h3>
% <text>
% <h3><a name=""#7_2_4">7.2.4  Processing Cell Arrays</a></h3>
% <text>
% ...
% <then, at the bottom:>
% <table align="center">
% 	<tbody>
% 		<tr>
% 			<td><a href="06_Strings.htm">previous</a></td>
% 			<td><a href="Contents.htm">home</a></td>
% 			<td><a href="08_File_I_O.htm">next</a></td>
% 		</tr>
% 	</tbody>
% </table>
% 
% </body>
% </html>


% logic
% 1. open three files - inputs and an output file mod to skeleton_name
% 2. copy skeleton down to </table>
% 3. extract chapter number and title
% Repeat
% 4. read a full line
% 5. extract and store heading
% until line not empty and not starting with chapter num
% 6. Read down to Chapter Objectives
% 7. Output heading
% 8. Read down to Introduction
% 9. Output heading
% Repeat
% 10. copy down to heading
% 11. output heading and <a name
% until input empty
% copy nav block to the end.
    global skel
    global text
    global out
    global dlim
    global headers
    global last_n
    global finish
    
    dlim = [' ', char(9)];
    finish = false;
    headers = [];
% 1. open three files - inputs and an output file mod to skeleton_name
    skel = fopen(skeleton_name,'r');
    if(skel <= 0)
        printf('bad skel name');
        return
    end
    text = fopen(text_name,'r');
    if(text <= 0)
        printf('bad text name');
        return
    end
    out_name = [skeleton_name(1:end-4) '_new.htm']
    out = fopen(out_name, 'w');
% 2. copy skeleton down to </table>
    scan_file(skel, '</table>', true);
    fprintf(out,'</table>\n');
% 3. extract and output chapter number and title
    [chapter, title] = get_chapter();
    chap_n = str2num(chapter);
    fprintf(out,'<ul>\n');  % open chapter list
% Repeat
    done = false;
    last_n = 1;

    while ~done
% 4. read a full line of text
        line = fgetl(text);
% 5. extract and store heading
        if length(line) > 0
            cn = strtok(line,'.');
            n = str2num(cn);
% until line not empty and not starting with chapter num
            done = n ~= chap_n;
            if(~done) 
                process_header(line);
            end
        end
    end
    fprintf(out,'</ul>\n');  % close chapter list
% 6. Read down to Chapter Objectives
    ok = strcmp('Chapter',line(1:length('Chapter')));
    if ~ok
        fprintf('didn''t find Chapter\n');
        error('oops')
    end
% 7. Output heading
    fprintf(out,'<h1>Chapter Objectives</h1>\n');
% 8. Read down to Introduction
scan_file(text, 'Introduction', true);
% 9. Output heading
    fprintf(out,'<h1>Introduction</h1>\n');
    for hdr_ndx = 1:length(headers);
% Repeat
        look_for = headers{hdr_ndx};
        need = strtok(look_for, dlim);
% 10. copy down to heading
        line = scan_first(text, need, true);
% 11. output heading and <a name
        tag = strtok(line, dlim);
        tag(tag == '.') = '_';
        n = length(find(tag == '_')) + 1;
        fprintf(out,'\n<h%d><a name="%s">%s</a></h%d>\n', n, tag, line, n);
    end
    % copy all remaining text
    done = false;
    while ~done
        line = fgetl(text);
        done = ~ischar(line);
        if ~done
            fprintf(out, '%s\n', line);
        end
    end
% copy nav block to the end.
    fclose(skel);
    skel = fopen(skeleton_name,'r');
    if(skel <= 0)
        printf('bad skel name');
        return
    end
% read skeleton down to </table>
    scan_file(skel, '<h1', false);
% copy to the end
    scan_file(skel, 'XXXXXXXXXXXXXXXXXXX', true);
    fclose(out)
end

function process_header(line)
    global skel
    global text
    global out
    global dlim
    global headers
    global last_n
    % save the line in headers
    headers = [headers {line}];
    
    % write out the complete header with tag:
% <ul>  done outside the loop
% first one will be level 2
    [token rest] = strtok(line, dlim);
    n = length(find(token == '.'));
    if last_n == 1 && n == 2
        fprintf(out, '<ul>\n');
    end
    if last_n == 2 && n == 1
        fprintf(out, '</ul>\n');
    end
    tag = token;
    tag(tag == '.') = '_';
% 	<li><a href="#6_1">6.1 Character String Concepts: </a>
    if(n == 1)
        fprintf(out,'<li><a href="#%s">%s</a>\n', tag, line);
    else
        fprintf(out,'    <li><a href="#%s">%s</a>\n', tag, line);
    end
    last_n = n;
end

function [ch, txt] = get_chapter()
    global text
    
    tkn = scan_file(text, 'CHAPTER', false)
    ch = tkn;
    found = false;
    while ~found
        line = fgetl(text);
        found = length(line > 2);
    end
    txt = line;
end

function line = scan_first(id, stop, write_it)
    global skel
    global text
    global out
    global dlim
    git_out = false;
    found = false;
    while ~git_out && ~found
        line = fgetl(id);
        git_out = ~ischar(line);
        tkn = strtok(line, dlim);
        found = strcmp(tkn, stop);
        if ~found && write_it, fprintf(out, '%s ', line); end
        if found
            return
        end
    end
    if ~found
        fprintf('couldn''t find %s\n', stop);
        finish = true;
        return
    end
end

function tkn = scan_file(id, stop, write_it)
    global skel
    global text
    global out
    global dlim
    global finish
    git_out = false;
    found = false;
    while ~git_out && ~found
        line = fgetl(id);
        git_out = ~ischar(line);
        while ~found && length(line) ~= 0
            [token line] = strtok(line, dlim);
            found = strcmp(token, stop);
            if ~found && write_it, fprintf(out, '%s ', token); end
            if found
                [tkn] = strtok(line, dlim);
            end
        end
        if ~found && write_it, fprintf(out, '\n'); end
    end
    if ~found
        fprintf('couldn''t find %s\n', stop);
        finish = true;
        return
    end
end
