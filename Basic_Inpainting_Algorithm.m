close all
clear all
clc

% Read in the picture
original = double(imread('greece.tif'));


% Read in the magic forcing function
% In the actual assignment you just have to to this ----> load forcing;
% But because MATLAB Grader has some weird limit on filesize that we had to get around
% We have to do the lines below. Don't use these in your submission!

load forcing;
f = [original];

% Read in the corrupted picture which contains holes
load badpicture;

% Read in an indicator picture which is 1 where the
% pixels are missing in badicture
mask = double(imread('badpixels.tif'));

% Please initialise your variables here (see the instructions for the specific variable names)
% Initialise your iterations here ....

restored = badpic; % initialise the restored pictures to be the badpicture to start with

% ... You need to initialise the other restored picture, and the error vectors as well

% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));

% Display the corrupted picture in Figure 2
% .....
    
% Here is where you can do your picture iterations.
% To speed things up use "find" to find the locations of the missing pixels
[j, i] = find(mask ~= 0); % This stores all the locations in vectors i and j (row and column indices for each missing pixel)
% You might want to also store those locations in a different format

% You will need two images to store your iterations as you go forward
% Because you will be writing your next iteration into another image based on the current image
% Suppose "restored" is the current estimate of your solution at iteration k
% then you'll be processing "restored" and writing the output into "restored_tmp" for example as you visit each pixel
% So after each iteration, the next k+1th result is in "restored_tmp"
% which means after the kth iteration, you have to copy restored_tmp into restored to initialise the next iteration.
% This is synchronous updating. It turns out that this kind of updating isn't that good in this case but we are using it anyway.

total_iterations = 10;
for iteration = 1 : total_iterations,  % but you have to replace this number with the variable you use for your total iterations
   % stuff goes here
   % you have to iterate over all the missing pixels (don't iterate over the whole image!) only
     % and at each location you update your restored image using the 2D FDM equation in the assignment description
     % Remember to index a pixel value in a picture "pic" at row 3 and column 4 its pic(3, 4) 
   % And when you get to the 20th iteration, you store your restored image in "restored20" 
   % And after each iteration you calculate the std devation between the original and restored images
   % but only in the location of the missing pixels!
end;

% Display the restored image in Figure 3 (This does NOT use the forcing function)
figure(3);
image(restored);
title('Restored Picture');
colormap(gray(256));

% Now repeat the restoration, again starting from the badpicture, but now use the forcing function in your update
% Remember the thing above about restored and restored_tmp
for iteration = 1 : total_iterations,
  % stuff ...
  % Remember to assign restored20_2 and err2
end;

% Display your restored image with forcing function as Figure 4

% And plot your two error vectors versus iteration
figure(5);
% Fix this !!!
plot((1 : 1000), rand(1, 1000), 'r-', (1 : 1000), rand(1, 1000), 'b-', 'linewidth', 3);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);


