function [R G, B] = billsML(image)
        
        I = imread(image);

        R = median(median(I(:,:,1)));
        G = median(median(I(:,:,2)));
        B = median(median(I(:,:,3)));
        
end