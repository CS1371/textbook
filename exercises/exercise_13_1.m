% Exercise 13.1
pic = imread('<your_favorite_image.jpg');
[rows, cols, clrs] = size(pic);
imshow(pic(2:2:end, 3:3:end, :));
RFactor = 1.43; CFactor = 0.75; % shrink / stretch factors
rowVec = round(linspace(1, rows, Rfactor*rows));
colVec = round(linspace(1, cols, Cfactor*cols));
imshow(pic(rowVec, colVec,:)); % shrunk / stretched image
imshow(pic(:, :, [2 3 1])); % re-ordering the color layers