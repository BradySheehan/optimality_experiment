function [K] = IterativeCurvatureMinEpsilon(Io)
% padarray with the reflection of the image itself
Io = padarray(Io,[1 1],'symmetric');
% returned variable
I = Io;

[xo,yo] = size(I);
K = zeros(xo,yo);
epsilon = realmin;
for i = 2 : xo - 1
        for j = 2 : yo - 1
            %-------------------------------------------------------------------------------------
            % distributing the backward difference (x dir) of the first quotient (X) term we have
            %-------------------------------------------------------------------------------------
            % forward difference (x dir) at (i,j)
            IxfX = I(i + 1, j) - I(i, j);
            
            % forward difference (y dir) at (i,j)
            IyfX = I(i, j + 1) - I(i, j);
            
            % backward difference (y dir) at (i,j)
            IybX = I(i, j) - I(i, j - 1);
            
            % forward difference (x dir) at (i - 1, j)
            Ixf1X = I(i, j) - I(i - 1, j);
            
            % forward difference (y dir) at (i - 1, j)
            Iyf1X = I(i - 1, j + 1) - I(i - 1, j);
            
            % backward difference (y dir) at (i - 1, j)
            Iyb1X = I(i - 1, j) - I(i - 1, j - 1);
            
            % disp(IxfX); disp(IyfX); disp(IybX);
            % disp(Ixf1X); disp(Iyf1X); disp(Iyb1X);
            %-------------------------------------------------------------------------------------
            
            %-------------------------------------------------------------------------------------
            % distributing the backward difference (y dir) of the second quotient (Y) term we have
            %-------------------------------------------------------------------------------------
            % forward difference (y dir) at (i,j)
            IyfY = IyfX;
            % forward difference (x dir) at (i,j)
            IxfY = IxfX;
            % backward difference (x dir) at (i,j)
            IxbY = I(i, j) - I(i - 1, j);
            
            % forward difference (y dir) at (i, j - 1)
            Iyf1Y = I(i, j) - I(i, j - 1);
            % forward difference (x dir) at (i, j - 1)
            Ixf1Y = I(i + 1, j - 1) - I(i, j - 1);
            % backward difference (x dir) at (i, j - 1)
            Ixb1Y = I(i, j - 1) - I(i - 1, j - 1);
            
            % disp(IxfY); disp(IyfY); disp(IybY);
            % disp(Ixf1Y); disp(Iyf1Y); disp(Iyb1Y);
            %-------------------------------------------------------------------------------------
            
            %-------------------------------------------------------------------------------------
            % first quotient term
            X = (IxfX / (sqrt((IxfX)^2 + (minmod(IyfX, IybX))^2) + epsilon)) - (Ixf1X / (sqrt((Ixf1X)^2 + (minmod(Iyf1X, Iyb1X))^2) + epsilon));
            %-------------------------------------------------------------------------------------
            %-------------------------------------------------------------------------------------
            % second quotient term
            Y = (IyfY / (sqrt((IyfY)^2 + (minmod(IxfY, IxbY))^2) + epsilon)) - (Iyf1Y / (sqrt((Iyf1Y)^2 + (minmod(Ixf1Y, Ixb1Y))^2) + epsilon));
            %-------------------------------------------------------------------------------------
       K(i,j) = X + Y;
        end
end

%-------------------------------------------------------------------------------------
% crop the image to original size
K = K(2: xo - 1, 2 : yo - 1);
%-------------------------------------------------------------------------------------

end

function [m] = minmod(a,b)

m = ((sign(a) + sign(b))/2) * min(abs(a),abs(b));

end