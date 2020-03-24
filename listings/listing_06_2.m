% listing_06_1
% Encryption
function main
    txt = [ 'The quality of mercy is not strain''d' ];
    fprintf('original text: %s\n', txt);
    seed = 1234578;
    res = encrypt(txt, seed);
    fprintf('encrypted text: %s\n', res);
    back = decrypt(res, seed, false);  % decrypt with correct settings
    good = 'matched';
    if ~strcmp(txt, back)
        good = 'not matched';
    end
    fprintf('decrypted text with right values: %s (%s)\n', back, good);
    back = decrypt(res, seed+1, false);  % decrypt with bad seed
    good = 'matched';
    if ~strcmp(txt, back)
        good = 'not matched';
    end
    fprintf('decrypted text with bad seed: %s (%s)\n', back, good);
    back = decrypt(res, seed, true);  % decrypt with bad generator
    good = 'matched';
    if ~strcmp(txt, back)
        good = 'not matched';
    end
    fprintf('decrypted text with bad generator: %s (%s)\n', back, good);
end

function res = encrypt(txt, seed)
% encrypt txt with the 'twister' generator and the given seed
% usage: function res = encrypt(txt, seed)
%   txt: text to encrypt
%  seed: seed value for the generator
    rng(seed, 'twister')
% solve the wrap-around cases 
    % set wraparound bounds and range
    loch = 33; hich = 126; range = hich+1-loch;
    % generate random integer array with length of text
    %  and values 0 .. range - 1
    rn = floor( range * rand(1, length(txt) ) );
    % only change the letters within legal bounds
    change = (txt>=loch) & (txt<=hich);
    % make a copy of txt
    enc = txt;
    % add random num to legal characters
    enc(change) = enc(change) + rn(change);
    % since this is addition, can't go below loch
    % wrap encrypted values off to the right 
    enc(enc > hich) = enc(enc > hich) - range;
    % return the result
    res = char(enc);
end

function res = decrypt(txt, seed, change_gen)
% decrypt txt with the given seed, maybe change the generator
% usage: function res = decrypt(txt, seed, change_gen)
%        txt: text to encrypt
%       seed: seed value for the generator
% change_gen: logical - if true, change the generator
    if change_gen
        rng(seed, 'v4');
    else
        rng(seed, 'twister');
    end
% solve the wrap-around cases 
    % set wraparound bounds and range
    loch = 33; hich = 126; range = hich+1-loch;
    % generate random integer array with length of text
    %  and values 0 .. range - 1
    rn = floor( range * rand(1, length(txt) ) );
    % only change the letters within legal bounds
    change = (txt>=loch) & (txt<=hich);
    % make a copy of txt
    dec = txt;
    % since this is subtraction, can't go above hich
    % however, must wrap decrypted values off to the left
    %  because they could have negative indices
    dec(change) = dec(change) - rn(change) + range;
    % then wrap the characters we just moved beyond hich
    dec(dec > hich) = dec(dec > hich) - range;
    % return the result
    res = char(dec);
end

