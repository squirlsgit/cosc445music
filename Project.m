clear;
keyboard = imread('keyboard.png');%picture of keyboard 
vid = VideoReader('keyboard.mp4');
frameone = 0;
frametwo = 0;
framethree = 0;
framefour = 0;
Notes = [];
if hasFrame(vid)
    firstframe = readFrame(vid);
    frame = 1;
    frameone = frame;
end
while hasFrame(vid)
    frame = frame + 1;
    currentFrame = readFrame(vid);
        Notes = keypresses(currentFrame,firstframe,firstframe,30,frame,Notes);
    
end

%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------

