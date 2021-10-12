mue = 1.32712e11; %km^3 /s^2

r2 = 0.5 * 1.495e8;
a2 = 0.635 * 1.495e8;

r1 = 0.5 * 1.495e8;
a1 = 0 * 1.498e8;
%Dv = sqrt( ((2*mue)/(r2))  -  ((mue)/(a2))) - sqrt( ((2*mue)/(r1))  -  ((mue)/(a1)));
Dv = sqrt( ((2*mue)/(r2))  -  ((mue)/(a2)));
disp(Dv);

