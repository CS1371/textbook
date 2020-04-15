cd listings
st = dir('*.m');
names = {st.name};
names = names(startsWith(names, 'listing_'));
mkdir livelistings
for i = 1:length(names)
    name = names{i};
    copyfile(name, 'livelistings');
    cd livelistings
    matlab.internal.liveeditor.openAndSave(which(name), sprintf('%s_live.mlx', names{i}(1:end-2)));
    delete(name);
    cd ..
end
cd ..