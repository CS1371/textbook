% listing_06_1
% Encryption
clear; clc
    txt = [ 'The quality of mercy is not strain''d' ]
    res = encrypt(txt);
    back = decrypt(res);
    good = strcmp(txt, back);
    res = try_to_crack_1(res);
    good = strcmp(txt, res);
    res = try_to_crack_2(res);
    good = strcmp(txt, res);

function res = encrypt(txt)
    rand( 'state' , 123456)
    loch = 33; hich = 126; range = hich+1-loch;
    rn = floor( range * rand(1, length(txt) ) );
    change = (txt>=loch) & (txt<=hich);
    enc = txt;
    enc(change) = enc(change) + rn(change);
    enc(enc > hich) = enc(enc > hich) - range;
    disp( 'encrypted text' )
    res = char(enc)
end

function res = decrypt(txt)
    % % good decryption
    rand( 'state' , 123456);
    loch = 33; hich = 126; range = hich+1-loch;
    rn = floor( range * rand(1, length(txt) ) );
    change = (txt>=loch) & (txt<=hich);
    dec = txt;
    dec(change) = dec(change) - rn(change) + range;
    dec(dec > hich) = dec(dec > hich) - range;
    res = char(dec)
end

function res = try_to_crack_1(txt)
    % % bad seed
    rand( 'seed' , 123457);
    loch = 33; hich = 126; range = hich+1-loch;
    rn = floor( range * rand(1, length(txt) ) );
    change = (txt>=loch) & (txt<=hich);
    dec = txt;
    dec(change) = dec(change) - rn(change) + range;
    dec(dec > hich) = dec(dec > hich) - range;
    disp( 'decrypt with bad seed' )
    res = char(dec)
end

function res = try_to_crack_2(txt)
    % % different generator
    rand('seed', 123456)
    loch = 33; hich = 126; range = hich+1-loch;
    rn = mod(floor( range * abs(randn(1, length(txt) ))/10 ), ...
        range);
    change = (txt>=loch) & (txt<=hich);
    dec = txt;
    dec(change) = dec(change) - rn(change) + range;
    dec(dec > hich) = dec(dec > hich) - range;
    disp( 'decrypt with wrong generator' )
    res = char(dec)
end
