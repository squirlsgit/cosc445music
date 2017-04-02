clear;
keyboard = imread('keyboard.png');%picture of keyboard 

detect = '4.png'; %change number to change picture of key being played

pressedKey = imread(detect);%is picture of key being pressed

threshold = 0.7;

%convert image to b&w
keyboard = im2bw(keyboard, threshold);
key = im2bw(pressedKey, threshold);

%open and close both images to get better edge definition
se = strel('disk',20);
se2 = strel('square',1);

keyboard = imopen(keyboard,se);
keyboard = imclose(keyboard,se2);

key = imopen(key,se);
key = imclose(key,se2);


%get difference of images
imdiff = imabsdiff(keyboard,key);

%open to get rid of small shadows
se = strel('disk',20);
imdiff = imopen(imdiff,se);


%draw boundaries on original image
[b,l] = bwboundaries(imdiff);
figure, imshow(pressedKey, []), hold on;

for k = 1:length(b),
    boundary = b{k};
    plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);    
end












