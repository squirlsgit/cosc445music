function output = keypresses(currentimage, backlog,background, framerate,currentframe,Notes) %background is image of keyboard. 
%currentimage is current image being analyzed for keypresses
%imagecomapre are images base is being compared to
%framerate is useful for timescale
%currentframe is number of frame being analyzed
%Notes is an array that was previously returned. tracks what notes have
%been done.

%--crop images
threshold = 0.7;
sobeledges = im2bw(background, threshold); 
sobeledges = imopen(sobeledges,strel('disk',10));
measurements = regionprops(sobeledges,'BoundingBox');
sumheight= 0;
sumwidth = 0;
for i = 1:size(measurements,1)
    sumheight = max(sumheight,measurements(i).BoundingBox(4));
   sumwidth = sumwidth + measurements(i).BoundingBox(3); 
end
rect = [floor(measurements(1).BoundingBox(1)),floor(measurements(1).BoundingBox(2)),ceil(sumwidth),ceil(sumheight)];
piano = imcrop(sobeledges, rect);


%--rotate image--UNFINISHED
%{
%%--Detect Edges--
fullsobel = edge(sobeledges,'sobel');
fullsobel = imdilate(fullsobel, strel('line',10,90));

%%--rotate with hough used on fullsobel
[H T R] = hough(fullsobel);
peaks = houghpeaks(H);
imshow(H); 
imshow(fullsobel,[]);
theta = T(peaks(1));
imrotate(fullsobel,theta);
%}


%--Label Keys
L = bwlabel(sobeledges);

%--detect pixel intensity change
keyboard = im2bw(backlog, threshold);
key = im2bw(currentimage, threshold);
se = strel('disk',10);
se2 = strel('square',1);
keyboard = imopen(keyboard,se);
keyboard = imclose(keyboard,se2);
key = imopen(key,se);
key = imclose(key,se2);
%imshow(keyboard);
%imshow(key);
%get difference of images
imdiff = imabsdiff(keyboard,key);

%open to get rid of small shadows
se = strel('disk',20);
imdiff = imopen(imdiff,se);


%--detect key presses with image difference
Noteholder = [];
for i = 1:size(L,1)
    for j = 1: size(L,2)
        if imdiff(i,j)>0 
            if L(i,j)>0
                if isempty(find(Noteholder == L(i,j)))
                    Noteholder = [Noteholder [L(i,j); currentframe]];
                end
            end
        end
    end
end


%--detect flat or sharp key presses
%%--invertpiano
invertpiano = 1 - piano;
invertpiano = imerode(invertpiano,strel('disk',15)); 
Linvert_crop = bwlabel(invertpiano);
Linvert = zeros(size(L,1),size(L,2));
Linvert(rect(2):rect(4)+rect(2),rect(1):rect(3)+rect(1)) = Linvert_crop;
%imshow(Linvert,[]);

%%--detect pixel intensity change
keyboard = im2bw(backlog, threshold);
key = im2bw(currentimage, threshold);
se = strel('disk',10);
se2 = strel('square',1);
keyboard = imopen(keyboard,se);
keyboard = imclose(keyboard,se2);
key = imopen(key,se);
key = imclose(key,se2);

%%--crop backlog and currentimages
measurements = regionprops(keyboard,'BoundingBox');
sumheight= 0;
sumwidth = 0;
for i = 1:size(measurements,1)
    sumheight = max(sumheight,measurements(i).BoundingBox(4));
   sumwidth = sumwidth + measurements(i).BoundingBox(3); 
end
rect = [measurements(1).BoundingBox(1),measurements(1).BoundingBox(2),sumwidth,sumheight];
keyboard_piano = imcrop(keyboard, rect);
keyboard_inv = 1 - keyboard_piano;
keyboardinvert_sharp= zeros(size(L,1),size(L,2));
keyboardinvert_sharp(rect(2):rect(4)+rect(2),rect(1):rect(3)+rect(1)) = keyboard_inv;
%imshow(Linvert,[]);

measurements = regionprops(key,'BoundingBox');
sumheight= 0;
sumwidth = 0;
for i = 1:size(measurements,1)
    sumheight = max(sumheight,measurements(i).BoundingBox(4));
   sumwidth = sumwidth + measurements(i).BoundingBox(3); 
end
rect = [measurements(1).BoundingBox(1),measurements(1).BoundingBox(2),sumwidth,sumheight];
key_sharp = imcrop(key, rect);
key_inv = 1 - key_sharp;
key_invert_sharp = zeros(size(L,1),size(L,2));
key_invert_sharp(rect(2):rect(4)+rect(2),rect(1):rect(3)+rect(1)) = key_inv;

 
%--get difference of images
imdiff = imabsdiff(keyboardinvert_sharp,key_invert_sharp);

%--open to get rid of small shadows
se = strel('disk',20);
imdiff = imopen(imdiff,se);

figure,imshow(key_sharp,[]);
figure, imshow(imdiff, []);
figure,imshow(key_invert_sharp,[]);
figure,imshow(keyboardinvert_sharp,[]);
%--detect sharp key presses with image difference
for i = 1:size(Linvert,1)
    for j = 1: size(Linvert,2)
        if imdiff(i,j)>0 
            if Linvert(i,j)>0 && L(i,j) == 0
                if isempty(find(Noteholder == Linvert(i,j)+200))
                    Noteholder = [Noteholder [Linvert(i,j)+200; currentframe]];
                end
            end
        end
    end
end

output = [Notes Noteholder]; %output should be a 2day array of integers identifying which labels are being pressed in what frames or time. 
end




