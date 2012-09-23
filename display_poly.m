function display_poly(num, denum, name, character, factorized)
% This function is used to display polynomials nicely.
% Arguments:
% - num: coefficient of the polynomial or of the numerator of the fraction
% - denum: denumerator of the fraction. If no need set it to 1
% -  name: name of the polynomial
% - character: symbol of the variable
% - factorized: 'factorized' if you want to display the polynomial in its factorized
% forms else in its developped forms.
% 
% Written by Louis Saint-Raymond

line1= [name,'(',character,') = '];

if strcmp(factorized,'factorized')
    text1 = Poly_factorization(num,character);
    if denum==1 %it is a polynomial
        poly = strcat('$$',line1,text1,'$$');
    else %it is a fraction
        text2 = Poly_factorization(denum,character);
        poly = strcat('$$',line1,'\frac{',text1,'}{',text2,'}$$');
    end
    poly=strrep(poly,'+0+','+');
    poly=strrep(poly,'+0-','-');
    poly=strrep(poly,'+1i','+i');
    poly=strrep(poly,'-1i','-i');
   
else
    %write num in char format
    t=poly2sym(num,character);
    text1=char(vpa(t,6));
    text1=strrep(text1,'.0*','');
    text1=strrep(text1,'*','');
    if denum==1 %it is a polynomial
        poly=strcat('$$',line1,text1,'$$');

    else    %it is a fraction      
        %write denum in char format
        t=poly2sym(denum,character);
        text2=char(vpa(t,6));
        text2=strrep(text2,'.0*','');
        text2=strrep(text2,'*','');
        poly=strcat('$$',line1,'\frac{',text1,'}{',text2,'}$$');
    end
end
cla
poly=replace_e(poly); % replace e by 10^
text(0,0.5,poly,'interpreter','Latex','fontsize',12)

function [P_factorized]=Poly_factorization(P,character)
%This function is used to factorize polynomials
%Arguments:
% - P: the polynomial
% - character: symbol of the variable
% Output: a string of the factorized polynomial
%
% Written by Louis Saint-Raymond

P_roots = poly_roots(P);
if isempty(P_roots) == 1
    P_factorized = num2str(P,3);
    return
end
P_size=size(P_roots);
P_roots=round(P_roots*1000)/1000; % display only 3 digits
nb_rows=P_size(1,1);
poly=[];
if P(1) ~= 1
    if P(1) == -1
        poly='-';
    else
        poly=num2str(P(1));
    end
end
for i=1:nb_rows
    
    if sign(real(P_roots(i,1))) == 1
        symbol = '-';
    else
        symbol = '+';
        P_roots(i,1)=-P_roots(i,1);
    end
    
    if P_roots(i,1)==0
        factor1 = character;
    else
        factor1 = strcat('(',character,symbol,num2str(P_roots(i,1),3),')');
    end
    
    if P_roots(i,2) ~= 1 % Multiple root
        factor = [factor1,'^',num2str(P_roots(i,2),3)];
    else
        factor = factor1;
    end      
    poly=[poly,factor];
end
if length(P)==2 % if only one factor, remove brackets, ie (z-5) --> z-5
    poly=regexprep(poly,{'(',')'},'');
end
P_factorized = poly;

function [string_without_e]=replace_e(string)
%This function replaces the string eXYY by 10^XYY. 
%For instance, e08 by 10^8, or e^-12 by 10^-12

expr = 'e([+-]\d+)'; % begin with a 'e', followed by '1' or '-' and then by several numeric digits
token = regexp(string,expr,'tokens'); % extract words corresponding to expr
if isempty(token)
    string_without_e = string;
else
    replace=str2double([token{:}]);
    string_without_e = string;
    for i=1:length(replace)
        old_part = strcat('e', token{i});
        new_part = strcat('\cdot10^{',num2str(replace(i)),'}');
        string_without_e=strrep(string_without_e,old_part,new_part);
    end
end


function Z = poly_roots(p)
%
% *** Solve multiple-root polymonials ***
%     Revised from polyroots.m
%     All are simple arithematic operations, except roots.m. 
%     F C Chang    05/22/12

      Z = [ ];
      mz = length(p)-max(find(p));
   if mz > 0,   Z = [Z; 0,mz];   end;
      p0 = p(min(find(p)):max(find(p)));
      sr = abs(p0(end)/p0(1));
   if sr < 1,   p0 = p0(end:-1:1);     end;
      np0 = length(p0)-1;
   if np0 == 0,   return,    end;
      q0 = p0(1:np0+1).*[np0:-1:0];
      g1 = p0/p0(1); 
      g2 = q0/q0(1);
  for k = 1:np0+np0,
      l12 = length(g1)-length(g2);  l21 = -l12;
      g3 = [g2,zeros(1,l12)]-[g1,zeros(1,l21)];
      g3 = g3(min(find(abs(g3)>1.e-8)):max(find(abs(g3)>1.e-8))); 
   if norm(g3,inf)/norm([g1,g2],inf) < 1.e-8,   break;   end;
   if l12 > 0,  
      g1 = g2;      end;
      g2 = g3/g3(1);
  end;
      g0 = g1;
      ng0 = length(g0)-1;                          % p0,q0,g0
   if ng0 == 0,
      z0 = roots(p0);  if sr < 1, z0 = z0.^-1;  end;
      Z = [Z; z0,ones(np0,1)];    return,
   end;
      nu0 = np0-ng0;                               % np0,ng0,nu0
      g0 = [g0,zeros(1,nu0)];   u0 = [ ]; v0 = [ ];
  for k =1:nu0+1,
      u0(k) = p0(k)-[u0(1:k-1)]*[g0(k:-1:2)].';
      v0(k) = q0(k)-[v0(1:k-1)]*[g0(k:-1:2)].';
  end;
      u0 = u0(1:nu0+1);
      v0 = v0(1:nu0);
      w0 = u0(1:nu0).*[nu0:-1:1];                  % u0,v0,w0
      z0 = roots(u0);  if sr < 1, z0 = z0.^-1;  end;
      A0 = (z0*ones(1,nu0)).^(ones(nu0,1)*(nu0-1:-1:0));
      m0 = (A0*v0')./(A0*w0');                     % A0,z0,m0
      Z = [Z; z0,round(abs(m0))];