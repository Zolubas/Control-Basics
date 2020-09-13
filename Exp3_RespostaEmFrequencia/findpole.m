function pole = findpole(w,G,wmin,rejmin,rejmax,wmax,Go)
%Instructions:
% To use this function use first the seedata() function and select a subset
%that make sense to be an assintota. To do this you just need to select
%this subset informing the min and max values of frequency w. 

% Find assintotic line equation
if rejmin == rejmax
    G_assintotic = G(find(w >=wmin & w <= wmax));
    w_assintotic = w(find(w >=wmin & w <= wmax));
else
    G_assintotic = G(find( (w >=wmin & w <= rejmin) | (w >= rejmax & w <= wmax) ));
    w_assintotic = w(find( (w >=wmin & w <= rejmin) | (w >= rejmax & w <= wmax) ));
end

r1 = polyfit(w_assintotic,G_assintotic,1);
% ax + b
a = r1(1);
b = r1(2);
display('Line coeficients [a,b]')
display(a)
display(b)

%Find pole
% 20*log10(ax + b) = Go
pole = (10.^(Go/20) - b)/a;

%Verifying the aspect of assintotic set of points
figure
semilogx(w_assintotic,G_assintotic,'o')
title('Assintotic set of points');
xlabel('w [rad/s]');
ylabel('|G| [dB]');

end