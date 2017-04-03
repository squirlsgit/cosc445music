function output = keypresses(baseimage, backlog,background, framerate) %background is image of keyboard. base image is current image being analyzed,
%imagecomapre are images base is being compared to, framerate is useful for timescale

baseimage = imread('keyboard.png'); %picture of keyboard.
keyboard = imread('keyboard.png');%picture of keyboard 

detect = '4.png'; %change number to change picture of key being played

pressedKey = imread(detect);%is picture of key being pressed

threshold = 0.7;

%convert image to b&w
keyboard = im2bw(keyboard, threshold);
key = im2bw(pressedKey, threshold);

%open and close both images to get better edge definition
se = strel('disk',10);
se2 = strel('square',1);

keyboard = imopen(keyboard,se);
keyboard = imclose(keyboard,se2);

key = imopen(key,se);
key = imclose(key,se2);

cannyedges = im2bw(baseimage, 0.7);
cannyedges = imopen(cannyedges,se);
canny = edge(cannyedges,'sobel');
canny = imdilate(canny, strel('line',10,90));
imshow(canny,[]);
%imshow(keyboard);
%imshow(key);
%get difference of images
imdiff = imabsdiff(keyboard,key);

%open to get rid of small shadows
se = strel('disk',20);
imdiff = imopen(imdiff,se);


%draw boundaries on original image
[b,l] = bwboundaries(imdiff);
figure, imshow(pressedKey, []), hold on;

for k = 1:length(b)
    boundary = b{k};
    plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);    
end

output = [0 0]; %output should be a 2day array of integers identifying which labels are being pressed in what frames or time.
end