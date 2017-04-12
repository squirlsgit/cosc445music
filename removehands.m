function output = removehands(I)
hands = rgb2hsv(I);
%imshow(hands);
H = hands(:,:,1);
S = hands(:,:,2);
V = hands(:,:,3);

Hmask = (H> 0.01) & (H < 0.1);
Smask = (S<0.6) & (S > 0.25);
Vmask = (V < 0.9) & (V > 0.45);
Result = Hmask & Smask & Vmask;
Result = imclose(Result,strel('disk',6)); 
output = Result;

end


