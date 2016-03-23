function [K] = CurvatureMinRGBFast(Io)
% padarray with the reflection of the image itself
Io = padarray(Io,[1 1],'symmetric');
% returned variable
I = Io;

%[xo,yo] = size(I);
xo = size(I,1);
yo = size(I,2);

K = zeros(xo,yo);
epsilon = realmin;
for rgb = 1:3
    
    for i = 2 : xo - 1
        for j = 2 : yo - 1
            X = ((I(i + 1, j,rgb) - I(i, j, rgb)) / (sqrt((I(i + 1, j,rgb) - I(i, j, rgb))^2 + (minmod((I(i, j + 1,rgb) - I(i, j,rgb)), (I(i, j,rgb) - I(i, j - 1,rgb))))^2) + epsilon)) - ((I(i, j,rgb) - I(i - 1, j,rgb)) / (sqrt(((I(i, j,rgb) - I(i - 1, j,rgb)))^2 + (minmod((I(i - 1, j + 1,rgb) - I(i - 1, j,rgb)), ( (I(i - 1, j,rgb) - I(i - 1, j - 1,rgb)))))^2) + epsilon));
            % second quotient term
            Y = ((I(i, j + 1,rgb) - I(i, j,rgb)) / (sqrt((( I(i, j + 1,rgb) - I(i, j,rgb)))^2 + (minmod(I(i + 1, j,rgb) - I(i, j, rgb), I(i, j,rgb) - I(i - 1, j,rgb)))^2) + epsilon)) - ((I(i, j,rgb) - I(i, j - 1,rgb)) / (sqrt(((I(i, j,rgb) - I(i, j - 1,rgb)))^2 + (minmod((I(i + 1, j - 1,rgb) - I(i, j - 1,rgb)), (I(i, j - 1,rgb) - I(i - 1, j - 1,rgb))))^2) + epsilon));
            
            K(i,j,rgb) = X + Y;
        end
    end
    
end
%-------------------------------------------------------------------------------------
% crop the image to original size
K = K(2: xo - 1, 2 : yo - 1,:);
%-------------------------------------------------------------------------------------

end

function [m] = minmod(a,b)

m = ((sign(a) + sign(b))/2) * min(abs(a),abs(b));

end