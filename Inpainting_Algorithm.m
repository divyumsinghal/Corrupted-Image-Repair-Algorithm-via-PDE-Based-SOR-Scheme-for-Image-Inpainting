close all
clear
clc


disp('This is the 2D FDM image restoration algorithm for the corrupted picture greece.tif');

% The frame greece.tif has been corrupted over time so that blocks are missing,
% and the frame we have now is (stored in badpicture.mat ).

% The corrupted picture has holes in it, and we want to restore it using the 2D FDM equation in the assignment description.
% The forcing function is stored in the file forcing.mat.

% greece.tif -      This contains the original uncorrupted picture as a TIFF file.
% badpicture.mat -  A matlab data file containing the corrupted image "badpic"
% badpixels.tif -   A TIFF image indicating the pixel sites in badpicture.mat that are corrupted. Each pixel is either 1 (corrupted site)

% The task is to design an algorithm that can fill-in the holes in the corrupted frame G so that it looks like the original O.


% Read in the picture
original = double(imread('greece.tif'));

% Read in the magic forcing function
load forcing;

% Read in the corrupted picture which contains holes
load badpicture;


% Read in an indicator picture- This stores all the locations in vectors missing_rows and missing_cols (row and column indices for each missing pixel)
mask = double(imread('badpixels.tif'));

% This stores all the locations in vectors missing_rows and missing_cols (row and column indices for each missing pixel)
[missing_rows, missing_cols] = find(mask ~= 0);

% This stores all the locations in a 2D array missing_pixels
missing_pixels = [missing_rows, missing_cols];  

total_iterations =  2500;           % This is the total number of iterations I will do
restored = badpic;                  % first I will initialize the restored pictures to be the badpicture to start with
% restored_forced = badpic;         % first I will initialize the restored pictures to be the badpicture to start with
restored_tmp = badpic;              % This is the temporary image I will use to store my iterations
restored20 = restored;              % This is the restored image after 20 iterations
restored20_forced = restored;       % This is the restored image after 20 iterations

% ... I need to initialize the other restored picture, and the error vectors as well
E = zeros(size(missing_pixels));        
err1 = zeros(size(total_iterations));   % error vector
err2 = zeros(size(total_iterations));   % error vector
a = 0.2;                                % This is the relaxation parameter for the update equation


% This displays the original picture in Figure 1
figure(1);
image(original);
title('Original');
colormap(gray(256));  
% drawnow; % Force MATLAB to display the image immediately


% Display the corrupted picture in Figure 2
figure(2);
image(badpic);
title('Corrupted Picture');
colormap(gray(256));
% drawnow; % Force MATLAB to display the image immediately


% Now I have to iterate over the missing pixels and update my restored image
% I will need two images to store my iterations as I go forward
% Because I will be writing my next iteration into another image based on the current image
% Suppose "restored" is the current estimate of my solution at iteration k
% then I'll be processing "restored" and writing the output into "restored_tmp" as I visit each pixel
% So after each iteration, the next k+1th result is in "restored_tmp"
% which means after the kth iteration, I have to copy restored_tmp into restored to initialise the next iteration.
% This is synchronous updating. 

for iteration = 1 : total_iterations
  
  E = zeros(size(missing_pixels));    

  % I have to iterate over all the missing pixels only (do not iterate over the whole image!)
  for pixel = 1 : length(missing_pixels)
    
    % I get the row and column of the missing pixel
    m = missing_pixels(pixel, 1);  % 530
    n = missing_pixels(pixel, 2);  % 640
    
    % and at each location I update my restored image using the 2D FDM equation in the assignment description
    % I will index a pixel value in a picture "pic" at row 3 and column 4 its pic(3, 4)
    % And when I get to the 20th iteration, I store my restored image in "restored20"
    % And after each iteration I calculate the std devation between the original and restored images
    % but only in the location of the missing pixels!

    E(pixel) = restored(m - 1, n) + restored(m + 1, n) + restored(m, n - 1) + restored(m, n + 1) - 4 * restored(m, n) - 0;
    %    = 135 + 0 + 134 + 134 + 0
    %    = 402
    
    % disp(I(m,n));
    % disp(E(pixel));
    % disp(I(m - 1, n));
    % disp(I(m + 1, n));
    % disp(I(m, n - 1));
    % disp(I(m, n + 1));
    % disp(I(m, n));
    % I(m, n) = restored_tmp;
   
    restored_tmp(m,n) = restored(m, n) + a * E(pixel);
    %            = 0 + 0.2 * 402
    %            = 80.4

    % reply = input('Do you want more? Y/N [Y]:','s');
    
  end

  restored = restored_tmp;

  % write a code here so that I can see how the restored image changes
  % after ever iteration

  % if mod(iteration, 500) == 0
  %       figure(3);
  %       image(I);
  %       title(['Restored Image after Iteration ', num2str(iteration)]);
  %       drawnow; % Force MATLAB to display the image immediately
  %       % pause(1); % Delays execution for 1 second
  % end

  % disp(iteration)

  err1(iteration) = mean(E, "all");

  if iteration == 20
    restored20 = restored;
  end
  
end


% Display the restored image in Figure 3 (This does NOT use the forcing function)
figure(3);
image(restored);
title('Restored Picture without forcing function');
colormap(gray(256));
% drawnow; % Force MATLAB to display the image immediately

% restored = badpic;


% Now I will repeat the restoration, again starting from the badpicture, but now use the forcing function in my update
for iteration = 1 : total_iterations
  
  E = zeros(size(missing_pixels));  

  for pixel = 1 : length(missing_pixels)
    
    % I get the row and column of the missing pixel
    m = missing_pixels(pixel, 1);
    n = missing_pixels(pixel, 2);

    E(pixel) = restored(m - 1, n) + restored(m + 1, n) + restored(m, n - 1) + restored(m, n + 1) - 4 * restored(m, n) - f(m,n);   

    restored_tmp(m,n) = restored(m, n) + a * E(pixel);

  end

  restored = restored_tmp;

  err2(iteration) = mean(E , "all");

  if iteration == 20
    restored20_forced = restored;
  end
  
end


% Display my restored image with forcing function as Figure 4
figure(4);
image(restored);
title('Restored Picture with forcing function');
colormap(gray(256));       
% drawnow; % Force MATLAB to display the image immediately


% And plot my two error vectors versus iteration
figure(5);
plot((1 : length(err1)), err1, 'r-', (1 : length(err2)), err2, 'b-', 'linewidth', 3);
legend('No forcing function', 'With forcing function');
xlabel('Iteration', 'fontsize', 20);
ylabel('Std Error', 'fontsize', 20);

disp("The end!");