% listing_05_2
% Function with if statements
clear; clc
    letter(92)
    letter(80)
    letter(79.9)
    letter(65)
    letter(21)

function letter(grade)
    % The first logical expression looks for the grade that earns an A.
    if grade >= 90
        % The corresponding code block sets the value of the variable
        % letter to 'A'.
        let = 'A'
        %% The next 5 lines contain the corresponding logic for letter
        % grades B, C, and D.
    elseif grade >= 80
        let = 'B'
    elseif grade >= 70
        let = 'C'
    elseif grade >= 60
        let = 'D'
        % The default logic setting the variable letter to 'F'.
    else
        let = 'F'
    end
end
