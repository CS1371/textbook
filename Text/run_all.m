function run_all
    clc
    close all
    cd 'listings'
    % dr = dir
    % for ndx = 1:length(dr)
    %     d = dr(ndx);
    %     name = d.name;
    %     if name(1) ~= '.'
    %         fprintf('%s\n', name(1:(end-2)));
    %     end
% %     end
    runit('listing_02_1');
    runit('listing_02_2');
    runit('listing_03_1');
    runit('listing_03_2');
    runit('listing_03_3');
    runit('listing_03_4');
    runit('listing_04_1');
    runit('listing_04_2');
    runit('listing_04_3');
    runit('listing_04_4');
    runit('listing_04_5');
    runit('listing_04_6');
    runit('listing_04_7');
    runit('listing_04_8');
    runit('listing_04_9');
    runit('listing_05_1');
    runit('listing_05_2');
    runit('listing_05_3');
    runit('listing_06_1');
    runit('listing_07_1');
    runit('listing_07_2');
    runit('listing_07_3');
    runit('listing_07_5');
    runit('listing_07_6');
    runit('listing_08_1');
    runit('listing_08_2');
    runit('listing_08_3');
    runit('listing_08_4');
    runit('listing_09_1');
    runit('listing_09_2');
    runit('listing_09_3');
    runit('listing_09_4');
    runit('listing_09_5');
    runit('listing_09_6');
    runit('listing_09_7');
    runit('listing_10_1');
    runit('listing_11_1');
    runit('listing_11_2');
    runit('listing_11_3');
    runit('listing_11_4');
    runit('listing_11_5');
    runit('listing_11_6');
    runit('listing_11_7');
    runit('listing_11_8');
    runit('listing_11_9');
    runit('listing_11_10');
    runit('listing_11_11');
    runit('listing_11_12');
    runit('listing_12_1');
    runit('listing_12_2');
    runit('listing_12_3');
    runit('listing_12_4');
    runit('listing_12_5');
    runit('listing_12_6');
    runit('listing_13_1');
    runit('listing_13_2');
    runit('listing_13_3');
    runit('listing_13_4');
    runit('listing_13_5');
    runit('listing_14_1');
    runit('listing_14_4');
    runit('listing_14_5');
    runit('listing_14_6');
    runit('listing_14_7');
    runit('listing_14_8');
    runit('listing_14_9');
    runit('listing_15_1');
    runit('listing_15_2');
    runit('listing_15_3');
    runit('listing_15_4');
    runit('listing_15_5');
    runit('listing_15_6');
    runit('listing_15_7');
    runit('listing_16_1');
    runit('listing_16_2');
    runit('listing_16_3');
    runit('listing_16_4');
    runit('listing_16_5');
    runit('listing_17_1');
    runit('listing_17_2');
    runit('listing_17_3');
    runit('listing_17_4');
    runit('listing_17_5');
    runit('listing_17_6');
    cd ..
end

function runit(str)
    fprintf('running %s\n', str);
    run(str);
end
