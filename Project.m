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
    if mod(frame,8) == 0
        lastframe = readFrame(vid);
        frametwo = frame;
    end
    if frameone ~= frametwo && frame >= 8
        %-- Detect and Print array of notes
        Notes = keypresses(lastframe,firstframe,firstframe,30,frame,Notes);
        firstframe = lastframe;
        frameone = frame;
    end
end

%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------

