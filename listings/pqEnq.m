function pq = pqEnq(pq, item)
% enqueue in order to a queue
	in = 1;
	at = length(pq)+1;
	while in <= length(pq)
        if is_before(item, pq{in})
            at = in;
            break;
        end
        in = in + 1;
	end
	pq = [pq(1:at-1) {item} pq(at:end)];
end
