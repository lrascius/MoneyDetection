% Project -- CSc 47900
% Presented to : Prof. J.Wei
% Presented by: Lukas Rascius & Markous Soliman
% Comments are provided.
% -----------------------------------------------------------%

function [] = billsCoinsDetection()

    % First, let's clean up the session
    clear;clc;clf;close all;
	format long;

    % Second, we are going to call the process function with an image to find 
    % real bills and coins and show the image with the objects detected.
     
    picture = 'image1.jpg';
    fprintf(' \n ---------------------------- \n Testing now %s \n ---------------------------- \n', picture);
    process(picture);    
    fprintf('\n ------------------- END OF TEST ------------------------ \n');
    
    picture = 'image2.jpg';
    fprintf(' \n ---------------------------- \n Testing now %s \n ---------------------------- \n', picture);
    process(picture);    
    fprintf('\n ------------------- END OF TEST ------------------------ \n');
    
    picture = 'image3.jpg';
    fprintf(' \n ---------------------------- \n Testing now %s \n ---------------------------- \n', picture);
    process(picture);    
    fprintf('\n ------------------- END OF TEST ------------------------ \n');
    
    
    % Function to process the given picture and call 2 different functions,
    % one for the bills detection and the other one for the coins detection    
    
    function process(picture)

        % Read in image into an array.
        I = imread(picture);

        figure(), imshow(I);

        findBills(I);
        hold on;
        findCoins(I);
    end

    function findCoins(image)

        grayImage = rgb2gray(image); 
    %   figure(), imshow(grayImage, []);    % COMMENTED FIGURE FASTER PROCESSING
           
        binaryImage = grayImage > 100;
        refinedImage = edge(grayImage,'canny', 0.4);
    %   figure, imshow(refinedImage)        % COMMENTED FIGURE FASTER PROCESSING
        
        ratio = decider('coins.jpg');       % Calls the function decider to get the ratios from the standard picture
        ratio = (ratio*100);
    
    %   bw = imfill(bw,'holes');            % fills the gaps 
        
    % calls the find circles using the gray scale image, and using weak
    % edges (0.2) with sensitivity (0.9)
        [centers, radii] = imfindcircles(grayImage,[24 80],'EdgeThreshold', 0.2, 'Sensitivity', 0.9);
        [radius ind] = sort(radii);         % Sorting the radius array
        centers_new = centers(ind,1);
        centers_new(:,2) = centers(ind,2);
    %   h = viscircles(centers_new, radii);     % COMMENTED CIRCLE DETECTION FOR FASTER PROCESSING
        
%         r = 0:1;                                % Range
%         comb = nchoosek(radius,2);              % Possible combinations of radiuses
%        
%         endloop = numel(comb)/2;                % End loop iterator
%         i = 1;                                  % Iterator
%         while i <= endloop
%             
%             check = comb(i,2) - comb(i,1);
%             
%             % checks if two circles are almost close in radius to each other.
%             if ((check >=min(r) & check <=max(r)) == true)      
%                 average = (comb(i,1)+ comb(i,2))/2;
%                 comb = changem(comb,[average average],[comb(i,1) comb(i,2)]);
%                 comb(i,:) = [];
%                 endloop = endloop - 1;
%             end
%             i = i + 1;
%         end
%         
%         radius_new = unique(comb)              % Unique array of new radius of circles
%         r = -0.5:0.5:0.5;                       % Range
%         
%         for i = 1:numel(radius_new)             % To remove repeated circles radiuses and centers
%             
%             flag = false;
%             endloop = numel(radius);
%             j = 1;
%             
%             while j <= endloop
%                 
%                 check = radius_new(i) - radius(j);
%                 
%                 if ((check >=min(r) & check <=max(r)) == true)
%                     if (flag == false)
%                         flag = true;
%                     else
%                         radius(j) = [];
%                         centers_new(j,:) = [];
%                         endloop = endloop - 1;
%                     end
%                 end
%                 j = j + 1;
%             end  
%         end
        
        
        radius_new = radius;            % sets the radius to a new array called radius_new

    %   figure(), imshow(image)         % COMMENTED FIGURE FASTER PROCESSING
        h = viscircles(centers_new, radius_new);        % prints the detected circles on the image
    
        % Prints numbers on the circles
        for i = 1:(numel(centers_new)/2)
            h = text(centers_new(i,1),centers_new(i,2), num2str(i), 'FontSize', 15);     
        end
        
        % Checks if it detects one or no circles in the image  (no
        % relations to other circles)
        if (size(radius_new,1) == 0 || size(radius_new,1) == 1)
            return;
        end
        
        comb = nchoosek(radius_new,2)
        image_ratio = zeros(floor(numel(comb)/2),1);
        
        for i = 1:(numel(comb)/2)
            
            image_ratio(i) = comb(i,1)/comb(i,2);       % An array holds the image coins' ratios.
        end
        
        image_ratio = (image_ratio*100);
        
        temp = 1:numel(radius_new);
        circle_no = nchoosek(temp,2);
        ratio2str = coinsNames;
        
        % Comparing the current image ratios with the standard ratios
        r = -4:4;           % Threshold for the ratios between the standard and the current image
        for i = 1:numel(image_ratio)

            fprintf('\n ---------------------------------------------------------- \n');
            fprintf('Relation between Circle %d and %d \n\n', circle_no(i,1) , circle_no(i,2));
            flag = false;        
            
            for j = 1: numel(ratio)

                check = image_ratio(i) - ratio(j);
                if (((check >= min(r)) & check <= max(r)) == true)
                    flag = true;
                    fprintf('%s to %s \n', ratio2str{j,1}, ratio2str{j,2});
                end  
            end
            
            if (flag == false)
                fprintf('Both are the same coin!');
            end
        end
    end

    function findBills(image)
        
        grayImage = rgb2gray(image); 
    %   figure(), imshow(grayImage, []);        % COMMENTED FIGURE FASTER PROCESSING
    
        binaryImage = grayImage > 100;
        refinedImage = edge(binaryImage,'canny', 0.4);
    %   figure(), imshow(refinedImage);         % COMMENTED FIGURE FASTER PROCESSING     
        
    %   background = imopen(refinedImage, strel('disk',100));
    %   filteredImage = refinedImage - background;
    %   Remove small objects.
        filteredImage = bwareaopen(refinedImage, 300);

        figure(), imshow(filteredImage);        % Figure to show the objects detected after applying canny's method
        
        [filledImage, locations] = imfill(filteredImage, 'holes');
        [labeledImage, numberOfObjects] = bwlabel(filledImage);
        boundaries = bwboundaries(labeledImage);
        billMeasurements = regionprops(labeledImage,'all'); 
        
        % Collect some of the measurements into individual arrays.
        perimeters = [billMeasurements.Perimeter];
        areas = [billMeasurements.Area];
        filledAreas = [billMeasurements.FilledArea];
        centers = [billMeasurements.Centroid];
        centers = floor(centers);
        extents = [billMeasurements.Extent];

        % Calculate circularities:
        circularities = (perimeters .^2) ./ (4 * pi * filledAreas);
        
        % Calculate the median of extents found by all objects
        medianEx = median(extents);
        thresholdEx = .15;      % Sets a threshold for the extent of objects
        
        [R_one G_one B_one]  = billsML('1dollar.jpg');      % Machine learning the one dollar bill from a different image
        [R_five G_five B_five]  = billsML('5dollar.jpg');   % Machine learning the five dollar bill from a different image
        [R_twenty G_twenty B_twenty]  = billsML('20dollar.jpg'); % Machine learning the twenty dollar bill from a different image
        
        figure(), imshow(image);
        
        %For loop to go throught the number of objects and detects the fake
        %bills from the real ones.
        
        for billNumber = 1 : numberOfObjects

            hold on;         
            flagC = false;              % Flag to the check the Circularity of each object
            flagE = false;              % Flag to check the Extent of each object.
            
            % Discard the object that has the circularity less than 1.3
            % (look more like circles)
            if (circularities(billNumber) > 1.3)
                flagC = true;
            end
            
            % Discard the object that has the exten within the set threshold
            % (look more like weird shapes)
            if ((extents(billNumber) >= (medianEx - thresholdEx)) && (extents(billNumber) <= (medianEx + thresholdEx)))
                flagE = true;
            end
            
            
            if (flagC && flagE)
                thisBoundary = boundaries{billNumber};
                plot(thisBoundary(:,2), thisBoundary(:,1), 'w--', 'lineWidth', 2);
                hold on;
                plot(centers((2*(billNumber-1)+1)), centers((2*(billNumber-1)+2)), 'r*')

            else
                continue;           % The object doesn't get considered as a bill
            end

            basicThreshold = 25;            % Basic color threshold
            secondaryThreshold = 50;        % Secondary color thershold 

            % finds the matrix of pixels in each object
            objectPixel = billMeasurements(billNumber).PixelList;
            c = unique(objectPixel, 'rows');
            picked = 1000;          % pick random 1000 pixels to get the color of the object
            randomNo = randi([1 size(c ,1)],1, picked);

            reds = zeros(1,picked);
            greens = zeros(1,picked);
            blues = zeros(1,picked);
            for i = 1:picked
                reds(1,i) = image(c(randomNo(i),2), c(randomNo(i),1),1);
                greens(1,i) = image(c(randomNo(i),2), c(randomNo(i),1),2);
                blues(1,i) = image(c(randomNo(i),2), c(randomNo(i),1),3);
            end
            
            % The best RGB for this color using the median of each array.
            bestRed   = median(reds);            
            bestGreen = median(greens);
            bestBlue  = median(blues);
    
            % IF statements to check the real bills and fake ones.
            if (bestRed <= (R_one + basicThreshold)) && (bestRed >= (R_one - basicThreshold)) && ...
                    (bestGreen <= (G_one + secondaryThreshold)) && (bestGreen >= (G_one - secondaryThreshold )) && ...
                    (bestBlue <= (B_one + secondaryThreshold)) && (bestBlue >= (B_one - secondaryThreshold )) && ...
                    (circularities(billNumber) < 1.7)
                        
                    h = text((centers((2*(billNumber-1)+1))-30), (centers((2*(billNumber-1)+2))+25), '\bf one dollar bill', 'FontSize', 10);
          
            elseif (bestRed <= (R_five + secondaryThreshold)) && (bestRed >= (R_five - secondaryThreshold)) && ...
                    (bestGreen <= (G_five + basicThreshold)) && (bestGreen >= (G_five - basicThreshold )) && ...
                    (bestBlue <= (B_five + secondaryThreshold)) && (bestBlue >= (B_five - secondaryThreshold)) && ...
                    (circularities(billNumber) < 1.7)
                          
                    h = text((centers((2*(billNumber-1)+1))-30), (centers((2*(billNumber-1)+2))+25), '\bf five dollar bill', 'FontSize', 10);
            
            elseif (bestRed <= (R_twenty + secondaryThreshold)) && (bestRed >= (R_twenty - secondaryThreshold)) && ...
                    (bestGreen <= (G_twenty + secondaryThreshold)) && (bestGreen >= (G_twenty - secondaryThreshold )) && ...
                    (bestBlue <= (B_twenty + basicThreshold)) && (bestBlue >= (B_twenty - basicThreshold)) && ...
                    (circularities(billNumber) < 1.7)      
            
                        
                    h = text((centers((2*(billNumber-1)+1))-30), (centers((2*(billNumber-1)+2))+25), '\bf twenty dollar bill', 'FontSize', 10);
             

            else
                    h = text((centers((2*(billNumber-1)+1))-30), (centers((2*(billNumber-1)+2))+25), '\bf Fake bill', 'FontSize', 10);
            end
        end
    end
end