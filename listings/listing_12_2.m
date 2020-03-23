% Simulating stars
function main
    % Sets the number of stars and the initial rotation angle
    nst = 20; th = 0;
    
    % Establishes the size, rotation, and speed of each star.
    for ndx = 1:nst
        pos(ndx,:) = rand(1,2)*10;
        scale(ndx) = rand(1,1) * .9 + .1;
        rate(ndx) = rand(1,1) * 3 + 1;
    end
    
    % Continue drawing until interrupted by Ctrl-C
    for frame = 1:20
        % Draw each star at the current rotation (see Listing 12.3 for the
        % star(...) function)
        for str = 1:nst
            star(pos(str,:), ...	% location
                scale(str), ... % scale
                th, ...	% basic angle
                rate(str))	% angle multiplier
        end
        
        % Choose a colormap with yellow as the first color
        colormap autumn
        
        % Show the normal display environment setup
        axis equal; axis([-.5 10.5 -.5 10.5])
        axis off; hold off
        
        % Updates the angle of rotation
        th = mod(th + .1, 20*pi);
        
        % Waits 1/10th of a second for the figure to be displayed. Without
        % this, the computation would be continuous and the user would
        % never see the result.
        pause(0.1)
    end
end