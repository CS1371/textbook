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
	a = side(1); b = side(2); c = side(3); 
	cosC = (c^2 - a^2 - b^2)/(2 * a * b);
	angle = acosd(cosC);
	if imag(angle) ~= 0
	   error('bad triangle')
	end
	fprintf('the angle is %f\n', angle)
end
