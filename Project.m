clear;
vid = VideoReader('keyboard.mp4');
frame = 0;
while hasFrame(vid)
    frame = frame + 1;
    im = readFrame(v);
end
keyboard = imread('keyboard.png');%picture of keyboard 
%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------
video = removehands('keypresses.asv', keyboard);


%-- Detect and Print array of notes


detect = '4.png'; %change number to change picture of key being played
pressedKey = imread(detect);%is picture of key being pressed
Notes = [];

Notes = keypresses(pressedKey,keyboard,keyboard,30,4,Notes);


