clear
clc
close all
global ORxmag
global ln
global P

P = [10,-20,32];
plot3([0 P(1)], [0 P(2)], [0 P(3)],'g*')
axis equal
grid on
hold on
xlabel('X')
ylabel('Y')
zlabel('Z')
text(0, -1, 0,'O');
str = sprintf('P [%2.2f, %2.2f, %2.2f]', P); 
text(P(1), P(2)-1, P(3),str);
ln = 30;
Q = P/2;
str = sprintf('Q [%2.2f, %2.2f, %2.2f]', Q); 
text(Q(1),Q(2)-1,Q(3), str);
mOQ = sqrt(P(1).^2 + P(2).^2 + P(3).^2)/2
QP = P - Q
alpha = atan2(P(2), P(1)) * 180/pi
R = [P(1), P(2), 0];
plot3( [R(1) 0 P(1)],[R(2) 0 P(2)],[R(3) 0 P(3)]) 
str = sprintf('R [%2.2f, %2.2f, %2.2f]', R); 
text(R(1), R(2)-1, R(3),str);
Pmag = sqrt(P(1)^2 + P(2)^2 + P(3)^2)
Pnorm = P ./ Pmag
Rmag = sqrt(R(1)^2 + R(2)^2 + R(3)^2);
Rnorm = R ./ Rmag
norm = cross(Pnorm, Rnorm);
norm = cross(norm, Q) * -1
Qmag = Pmag/2
QSmag = sqrt(ln^2 - Qmag^2)
norm_mag = sqrt(norm(1)^2 + norm(2)^2 + norm(3)^2);
norm = norm / norm_mag
S = Q + norm*QSmag
plot3([0 S(1) P(1)], [0 S(2) P(2)], [0 S(3) P(3)],'m')
str = sprintf('S [%2.2f, %2.2f, %2.2f]', S); 
text(S(1), S(2)-1, S(3),str);
Smag = sqrt(S(1)^2 + S(2)^2 + S(3)^2)
view(alpha, 0)
SP = S - P
SPmag = sqrt(SP(1)^2 + SP(2)^2 + SP(3)^2)
plot3([S(1) Q(1)],[S(2) Q(2)],[S(3) Q(3)], 'y') 
ORxmag = sqrt(P(1)^2 + P(2)^2)
OSxmag = sqrt(S(1)^2 + S(2)^2)
RSxmag = ORxmag - OSxmag;
beta = atan2(S(3), -OSxmag)*180/pi
gamma = atan2(P(3)-S(3), ORxmag + OSxmag)*180/pi
[f_of_beta, g] = f(beta)
ba = linspace(0, 360);
figure
plot(ba, f(ba))
grid on
title('f(beta) vs beta')
xlabel('beta')
ylabel('f(beta)')



function [fn gamma] = f(bet)
global ORxmag
global ln
global P
% create the solution for the equation
%               
%   1. horizontal: ln cos b + ln cos g = ORxmag 
%     ORxmagf = ln.*(cosd(bet)+cosd(gam))
%   2. vertical:   ln sin b + ln sin g = P(3)
%     P3f = ln .* (sind(bet) + sind(gam))
%   3. algebra:    cos g^2 + sin g^2 = 1
% from 1:   cos g = ORxmag/ln - cos b
% from 2:   sin g = P(3)/ln - sin b
% so in3:   (ORxmag/ln - cos b)^2 + (P(3)/ln - sin b)^2 - 1 = 0;
% mult by ln^2:
%            (ORxmag - ln cos b)^2 + (P(3) - ln sin b)^2 - ln^2 = 0;
% simplify:
%              ORxmag^2 - 2 ln ORxmag cos b + ln^2 cos b^2 
%   + P(3)^2 - 2 ln P(3) sin b + ln^2 sin b^2 - ln^2 = 0;
% using 3 again:
%   ORxmag^2 + P(3)^2 - 2 ln(ORxmag cos b + P(3) sin b) = 0
    cb = cosd(bet);
    sb = sind(bet);
    fn = ORxmag.^2 + P(3).^2 - 2.*ln.*(ORxmag.*cb + P(3).*sb)
    % tan g = sin G / cos G
    % g = atan2(sin g, cos g) * 180 / pi
    %   = atan2(P(3)/ln - sind(bet), RSxmag/ln - cos b)*180/pi;
    gamma = atan2(P(3)./ln - sind(bet), ORxmag./ln - cosd(bet))*180/pi
end


