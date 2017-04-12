clear;
keyboard = imread('keyboard.png');%picture of keyboard 
vid = VideoReader('keyboard.mp4');
frameone = 0;
frametwo = 0;
framethree = 0;
framefour = 0;
Notes = [];
threshold = 0.7;
if hasFrame(vid)
    firstframe = readFrame(vid);
    %-- ROTATE IMAGE with Hough. --
    %firstframe = imrotate(firstframe,30);
    bwframe = im2bw(firstframe, threshold); 
    sobelframe = edge(bwframe,'sobel');
    [H, theta, p] = hough(sobelframe);
    Peaks = houghpeaks(H,1);
    rotatebytheta = theta(Peaks(1,2));
    if 90 <= abs(rotatebytheta) && abs(rotatebytheta) <= 100 
        rotatebytheta = 0;
    else
        rotatebytheta = rotatebytheta -90;
    end
    firstframe = imrotate(firstframe, rotatebytheta);
    %imshow(firstframe);
    %-- CONTINUE --
    frame = 1;
    frameone = frame;
end
while hasFrame(vid)
    frame = frame + 1;
    currentFrame = readFrame(vid);
    %imshow(currentFrame);
    %-- ROTATE IMAGE with Hough. --
    %currentFrame = imrotate(currentFrame,30);
    bwframe = im2bw(currentFrame, threshold); 
    sobelframe = edge(bwframe,'sobel');
    [H, theta, p] = hough(sobelframe);
    Peaks = houghpeaks(H,1);
     rotatebytheta = theta(Peaks(1,2));
    if (90 <= abs(rotatebytheta) && abs(rotatebytheta) <= 100 )
        rotatebytheta = 0;
    else
        rotatebytheta = rotatebytheta -90;
    end
    currentFrame = imrotate(currentFrame, rotatebytheta);
    
    %%%%%%%%%%%%%%%%%%%%%
        Notes = keypresses(currentFrame,firstframe,firstframe,30,frame,Notes);
    
end

%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------

