function output = keypresses(currentimage, backlog,background, framerate,currentframe,Notes) %background is image of keyboard. 
%currentimage is current image being analyzed for keypresses
%imagecomapre are images base is being compared to
%framerate is useful for timescale
%currentframe is number of frame being analyzed
%Notes is an array that was previously returned. tracks what notes have
%been done.




%--Detect Edges--
threshold = 0.7
sobeledges = im2bw(background, threshold); 
sobeledges = imopen(sobeledges,strel('disk',10));
fullsobel = edge(sobeledges,'sobel');
%fullsobel = imdilate(fullsobel, strel('line',10,90));

%--rotate with hough--UNFINISHED
[H T R] = hough(fullsobel);
peaks = houghpeaks(H);
%imshow(H); 

%imshow(fullsobel,[]);
%theta = T(peaks(1));
%imrotate(fullsobel,theta);

%--detect regions
L = bwlabel(sobeledges);
coordinates = zeros(size(L,1),size(L,2),2);
for i = 1:size(L,1)
    for j = 1: size(L,2)
        if L(i,j)>0 
        coordinates(i,j,1) = 1;
        coordinates(i,j,2) = L(i,j);
        end
    end
end


%--detect key presses with image difference
%Noteholder;
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
%imshow(imdiff,[]);
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
output = [Notes Noteholder]; %output should be a 2day array of integers identifying which labels are being pressed in what frames or time. 
end




