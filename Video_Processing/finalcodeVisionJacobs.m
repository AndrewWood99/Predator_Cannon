%Vision Code for Predator Nerf Blaster
%Code uses 'creatMask.m' the mask was tuned inside the demo room with
%lights off, red was tuned in HSV scale to mask out nothing but the red
%laser, code runs web cam to about 30 seconds, and masks, binary, then
%dilates, then get centroids, and then gets average centroid of laser blob
%(3 laser dots) then sends the x and y position to a serial in for mbed to
%process angle error and correct IMU track errors
%Final Code by Ethan Jacobs and Nick Middlebrooks April 24th 2019

clc;
clear;
close all hidden;
cam = webcam(1); %set cam on predator gun arm

for idx = 1:400 %%400 frames and then stop program appx 30 seconds to track and shoot 
    %high frame rate
    rgbImage1 = snapshot(cam);
    [~,rgbImage]= createMask(rgbImage1);
    %I = rgb2hsv(rgbImage);
     b = im2bw(rgbImage);%Red color threshold mask from function
     a = 1-b; %swap black and white, not needed after mask
     %org image
     imshow(rgbImage);
     %dialate the laser dots into one big blob
     se = strel('sphere',6);
     BW2 = imdilate(b,se);
     
     stats = regionprops('table',BW2,'Centroid',...
    'MajorAxisLength','MinorAxisLength')
     s = regionprops(BW2,'centroid');
    % get the centroids of the glob
     centroids = cat(1,s.Centroid);
     % get one average value of the laser glob (to send position to angles
     % on Mbed for servo arm to correct IMU error)
     mid = nanmean(centroids);% reject NaN values for finding centroids
     hold on
     x = mid(:,1)
     y = mid(:,2)
     figure, plot(x,y,'r*')% shows average centroid pos as red star
   VisOut =[x y];

end
clear;