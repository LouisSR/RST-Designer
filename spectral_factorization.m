% This function does the spectral factorization of the polynomial B in taking
% account of the absolute and relative conditions
% 
% Written by Louis Saint-Raymond

function [Bminus,Bplus]=spectral_factorization(B, absolute_r, relative)
%Spectral Factorization of B = Bplus*Bminus
B_roots=roots(B);
if isempty(B_roots) %Bsyst has no zero
    Bplus=1;
    Bminus=B;
else
    Bplus=1;
    for i=1:length(B_roots)%All zeros < absolute and relative conditions in Bplus, others in Bminus
        module=abs(B_roots(i));
        phase=angle(B_roots(i));
        relative_r=exp(-relative.*abs(phase));%relative_condition
        if module<absolute_r && module<relative_r
            Bplus=conv(Bplus,[1 -B_roots(i)]);
        end
    end
    [Bminus, R]=deconv(B,Bplus);
    if R~=0
        disp('Error Bminus has a remainder')
    end
end