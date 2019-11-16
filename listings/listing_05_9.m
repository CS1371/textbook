% listing_05_9
% Script to compute liquid levels
clear; clc
    % Initialize another_tank to start the while loop code.
    another_tank = true;
    while another_tank
        % Get the tank dimensions.
        %%3.	H = input('Overall tank height: ');
        %%4.	r = input('tank radius: ');
        %%%%
        %   auto gen only
        rn = round(rand(1,2) * 100);
        H = rn(1);
        r = rn(2);
        %%%%
        % Initialize more_heights to start the inner while loop.
        more_heights = true;
        while more_heights
            % Get the liquid height.
            %	h = input('liquid height: ');
            %%%%
            %   auto gen only
            rn = round(rand(1,1) * 100);
            h = rn(1);
            %%%%
            %% Calculations for legal values of h. Notice that no
            % dot operators are required here, because these conditional
            % computations will not work correctly with vectors.
            if h < r
                v = (1/3)*pi*h.^2.*(3*r-h);
            elseif h < H-r
                v = (2/3)*pi*r^3 + pi*r^2*(h-r);
            elseif h <= H
                v = (4/3)*pi*r^3 + pi*r^2*(H-2*r) ...
                    - (1/3)*pi*(H-h)^2*(3*r-H+h);
            else
                % Illegal h values end up here.
                disp('liquid level too high')
                % Jump to the end of the inner loop, skipping the printout.
                continue
            end
            % Print the result.
            fprintf( ...
                'rad %0.2f ht %0.2f level %0.2f vol %0.2f\n', ...
                r,	H,	h,	v);
            % More levels when "y" is entered.
            %% 22.	more_heights = input('more levels? (y/n)','s')=='y';
            %%%%
            %   auto gen only
            rn = round(rand(1,1) * 100 - 50);
            more_heights = (rn > 0);
            %%%%
        end
        % Another tank when “y" is entered.
        %% 24.	another_tank = input('another tank? (y/n)','s')=='y';
        %%%%
        another_tank = false;
        rn = round(rand(1,1) * 100 - 50);
        if rn > 0
            another_tank = true;
        end
    end

