function [K] = IterativeCurvatureCentral(Io)
% padarray with the reflection of the image itself
Io = padarray(Io,[1 1],'symmetric');
% returned variable
I = Io;

[xo,yo] = size(I);
K1 = zeros(xo,yo);
epsilon = realmin;
for i = 2 : xo - 1
    for j = 2 : yo - 1
        fx=0.5*( I(i+1,j) - I(i-1,j) );
        fy=0.5*( I(i,j+1) - I(i,j-1) );
        fxx= I(i+1,j) + I(i-1,j) -2*I(i,j) ;
        fyy= I(i,j+1) + I(i,j-1) -2*I(i,j) ;
        fxy= (I(i+1,j+1) - I(i-1,j+1) - I(i+1,j-1) + I(i-1,j-1))/4.0;
        K1(i,j)=(fyy*fx*fx+fxx*fy*fy-2*fx*fy*fxy)/(power(fx*fx+fy*fy,1.5)+epsilon);
    end
end

%-------------------------------------------------------------------------------------
% crop the image to original size
K = K1(2: xo - 1, 2 : yo - 1);
%-------------------------------------------------------------------------------------

end

