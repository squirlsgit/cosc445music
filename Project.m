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
    bwframe = im2bw(firstframe, threshold); 
    sobelframe = edge(bwframe,'sobel');
    [H, theta, p] = hough(Cannyframe);
    Peaks = houghpeaks(H,1);
    rotatebytheta = 270-theta(Peaks(1,2));
    firstframe = imrotate(firstframe, rotatebytheta);
    %-- CONTINUE --
    frame = 1;
    frameone = frame;
end
while hasFrame(vid)
    frame = frame + 1;
    currentFrame = readFrame(vid);
    bwframe = im2bw(currentFrame, threshold); 
    sobelframe = edge(bwframe,'sobel');
    [H, theta, p] = hough(Cannyframe);
    Peaks = houghpeaks(H,1);
    rotatebytheta = 270-theta(Peaks(1,2));
    currentFrame = imrotate(currentFrame, rotatebytheta);
        Notes = keypresses(currentFrame,firstframe,firstframe,30,frame,Notes);
    
end

%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------

