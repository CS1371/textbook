%  listing_09_2
% script using exception processing
function main
    triangle([3, 4, 5])
	try
	   triangle([3, 6, 5])
	catch exc
	      er = getReport(exc)
    end
end

function triangle(side)
	a = side(1); b = side(2); c = side(3); % This will fail if the vector 
        % doesn't have at least 3 elements.
	cosC = (c^2 - a^2 - b^2)/(2 * a * b);
	angle = acosd(cosC); % Compute the angle. If the triangle is illegal 
        % this will return a complex number.
	if imag(angle) ~= 0
	   error('bad triangle') % Announce error and go back to catch block
	end
	fprintf('the angle is %f\n', angle) % This line is only reached if 
        % allocations and acosd call work properly.
end
