% Listing_17_2  comparing two objects
function ans = is_before(a, b)
    acl = class(a);
    ans = false;
    if isa(b, acl)
        switch acl
            case {'double' 'logical' 'uint8'}
                ans = a < b;
            case 'char'
                ans = strcmp(a,b);
            case 'struct'
                if isfield(a, 'key')
                    ans = a.key < b.key;
                elseif isfield(a, 'dod')
                    ans = age(a) < age(b);
                else
                    error('comparing unknown structures')
                end
            otherwise
                error(['can''t compare ' acl 's'])
        end
    end
end
