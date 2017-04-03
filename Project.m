clear;
keyboard = imread('keyboard.png');%picture of keyboard 
detect = '4.png'; %change number to change picture of key being played
pressedKey = imread(detect);%is picture of key being pressed
Notes = [];

Notes = keypresses(pressedKey,keyboard,keyboard,24,4,Notes);


