function output = keypresses(currentimage, backlog,background,handmask, framerate,currentframe,Notes) %background is image of keyboard. 
%currentimage is current image being analyzed for keypresses
%imagecomapre are images base is being compared to
%framerate is useful for timescale. is not used in current version.
%currentframe is number of frame being analyzed
%Notes is an array that was previously returned. tracks what notes have
%been done.
video_orig = rgb2gray(currentimage);
%--crop images
threshold = 0.7;
%sobel is a nondescriptive term. was being used for hough transform, but
%thats in project now.
sobeledges = im2bw(background,threshold);
%get rid of small particles
sobeledges = imopen(sobeledges,strel('disk',4));
%cleanup
sobeledges = imclose(sobeledges,strel('line',20,90));
measurements = regionprops(sobeledges,'BoundingBox');
sumheight= 0;
sumwidth = 0;
for i = 1:size(measurements,1)
    sumheight = max(sumheight,measurements(i).BoundingBox(4));
   sumwidth = sumwidth + measurements(i).BoundingBox(3); 
end
rect = [floor(measurements(1).BoundingBox(1)),floor(measurements(1).BoundingBox(2)),ceil(sumwidth),ceil(sumheight)];
piano = imcrop(sobeledges, rect);
L = bwlabel(sobeledges);
%imshow(L);
%--detect flat or sharp key presses
%%--invertpiano
invertpiano = 1 - piano;
invertpiano = imerode(invertpiano,strel('line',15,0)); 
invertpiano = imerode(invertpiano,strel('line',15,90)); 
Linvert_crop = bwlabel(invertpiano);
Linvert = zeros(size(L,1),size(L,2));
Linvert(rect(2):rect(4)+rect(2),rect(1):rect(3)+rect(1)) = Linvert_crop;
%imshow(Linvert,[]);
%imshow(L + Linvert,[]);
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

%imshow(L,[]);
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

%get difference of images to detect fingers
%Use smaller SE and new threshold so that fingers are not erased completely 
se3 = strel('disk',1);
se4 = strel('square',3); 
keyboardDiff=im2bw(backlog, 0.5);
keyDiff=im2bw(currentimage, 0.45);
keyboardDiff = imopen(keyboardDiff,se3);
keyboardDiff = imclose(keyboardDiff,se4);
keyDiff= imopen(keyDiff,se3);
keyDiff = imclose(keyDiff,se4);

imdiff = imabsdiff(keyboardDiff,keyDiff);

%open to get rid of small shadows
se = strel('disk',4);
imdiff = imopen(imdiff,se);
imdiff = imdiff - handmask;
%imshow(imdiff,[]);
%figure,imshow(imdiff,[]);
%figure,imshow(video_output,[]);

%--detect key presses with image difference
Noteholder = [];
for i = 1:size(L,1)
    for j = 1: size(L,2)
        if imdiff(i,j)>0 
            if Linvert(i,j)>0 
                if isempty(find(Noteholder == Linvert(i,j)+200))
                    Noteholder = [Noteholder [Linvert(i,j)+200; currentframe]];
                end
                       
            elseif L(i,j)>0
                 if isempty(find(Noteholder == L(i,j)))
                    Noteholder = [Noteholder [L(i,j); currentframe]];
                end    
            end
        end
    end
end

video_orig = im2double(video_orig);
video_output = [video_orig ; imdiff ; handmask; L + Linvert ];
imshow(video_output);

output = [Notes Noteholder]; %output should be a 2day array of integers identifying which labels are being pressed in what frames or time. 
end


