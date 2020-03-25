function K = trapezoid(v, a, b)
K = (b-a) * (v(1) + v(end) + ...
    2*sum(v(2:end-1))) / (2*(length(v) - 1));
end