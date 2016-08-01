function [ Km ] = CurvatureFwdBwd( I )
[xo,yo]=size(I);
Km = zeros(xo,yo);
beta = realmin;
hs=1;
for i = 2 : xo - 1
        for j = 2 : yo - 1
            
            fi= I(i,j+1) - I(i,j) ;
            bi= I(i,j) - I(i,j-1) ;
            fj= I(i+1,j) - I(i,j) ;
            bj= I(i,j) - I(i-1,j) ;
            ci=(I(i,j+1) - I(i,j-1))/2 ;
            ci1=(I(i+1,j-1) - I(i-1,j-1))/2 ;
            ci2=(I(i+1,j+1) - I(i-1,j+1))/2 ;
            cj=(I(i+1,j) - I(i-1,j))/2 ;
            cj1=(I(i-1,j+1) - I(i-1,j-1))/2 ;
            cj2=(I(i+1,j+1) - I(i+1,j-1))/2 ;
            D1x=fi/hs;   D2x=bi/hs; D3x=(ci2+ci)/(4*hs); D4x=(ci+ci1)/(4*hs); 
            D1y=(cj2+cj)/(4*hs); D2y=(cj+cj1)/(4*hs); D3y=fj/hs;  D4y=bj/hs; 
            normgrad1=sqrt(D1x*D1x + D1y*D1y + beta); normgrad2=sqrt(D2x*D2x + D2y*D2y + beta);
            normgrad3=sqrt(D3x*D3x + D3y*D3y + beta); normgrad4=sqrt(D4x*D4x + D4y*D4y + beta);
            curv= (D1x/normgrad1- D2x/normgrad2 + D3y/normgrad3 - D4y/normgrad4)/hs;
            Km(i,j)=curv;%+4;
        end
end
%Km = 255*(Km-min(min(Km)))/(max(max(Km))-min(min(Km)));% + 4*ones(size(Km));
end

