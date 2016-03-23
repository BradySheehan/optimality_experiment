function result = find_center(I)
%This function assumes I is of odd size and square
result = I(ceil(size(I,1)/2),ceil(size(I,2)/2));
end