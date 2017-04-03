clear;
keyboard = imread('keyboard.png');%picture of keyboard 
%-- REMOVE HANDS FROM VIDEO CODE
%%--TO BE IMPLEMENTED TO DO-------------
video = removehands('keypresses.asv', keyboard);


%-- Detect and Print array of notes


detect = '4.png'; %change number to change picture of key being played
pressedKey = imread(detect);%is picture of key being pressed
Notes = [];

Notes = keypresses(pressedKey,keyboard,keyboard,24,4,Notes);


