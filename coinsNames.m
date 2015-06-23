% Function that stores the strings of coins' names in a string array.
function [ratio2str] = coinsNames

    ratio2str = {};

    ratio2str{1,1} = 'Dime';
    ratio2str{2,1} = 'Dime';
    ratio2str{3,1} = 'Dime';

    ratio2str{1,2} = 'Penny';
    ratio2str{4,1} = 'Penny';
    ratio2str{5,1} = 'Penny';

    ratio2str{2,2}  = 'Nickel';
    ratio2str{4,2}  = 'Nickel';
    ratio2str{6,1}  = 'Nickel';

    ratio2str{3,2}  = 'Quarter';
    ratio2str{5,2}  = 'Quarter';
    ratio2str{6,2}  = 'Quarter';

end
