function [ratio] = decider(picture)

    I = imread(picture);
    level = graythresh(I);
    bw = im2bw(I,level);

    %decides centers and radiuses of found circles
    [centers, radius] = imfindcircles(bw,[40 100], 'Method', 'TwoStage','ObjectPolarity', 'dark', 'Sensitivity',0.94); 

    radius = sort(radius);   %sort the radius of coins

    % Specify an average radius to each coins' heads and tails.
    dime = (radius(1) + radius(2))/2;
    penny = (radius(3) + radius(4))/2;
    nickel = (radius(5) + radius(6))/2;
    quarter = (radius(7) + radius(8))/2;

    % An array holds the average radiuses
    money(1) = dime;
    money(2) = penny;
    money(3) = nickel;
    money(4) = quarter;

    % Possible combinations of the array contents
    moneyComb = nchoosek(money,2);

    for i = 1:(numel(moneyComb)/2)

        ratio(i) = moneyComb(i,1)/moneyComb(i,2); %storing the ratio in array called "ratio"
    end

end