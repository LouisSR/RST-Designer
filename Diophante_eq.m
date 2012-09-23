% This function solves the Diophante equation using the Sylvester matrix.
% %Generic diophante eq. : MX+NY=C
% X Y unknowns to search
% def_R and deg_S are the degrees of the polynomials of the RST controller
%
% Written by Louis Saint-Raymond

function [X Y]=Diophante_eq(M, N, C, deg_R, deg_S)
%Generic diophante eq. : MX+NY=C
% X Y unknowns to search

deg_M = length(M)-1;
deg_N = length(N)-1;

%Sylvester : Phi * X = C
Phi=zeros(deg_R+deg_S+2);
for i=1:deg_R+1
    Phi(i:deg_M+i,i)=M;
end
for i=deg_R+deg_S+2:-1:deg_R+2
    Phi(i-(deg_N):i,i)=N;
end
XY=Phi\C';

X=XY(1:deg_R+1,1);
Y=XY(deg_R+2:end,1);