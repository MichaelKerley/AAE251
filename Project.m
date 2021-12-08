%AAE 251 Fall 2021
%Homework <HW2>
%Atmosphere Matlab Problem
%Authors: <Michael Kerley>

MachNum = 0.6;
CruiseAltitude = 10000 * (0.3048); %10,000 feet converted to meters
[T1, V1, P1, rho1] = atmosisa(CruiseAltitude);
VCruise = V1 * 3.28084 * MachNum; %Converted back to ft/s

[T2, V2, P2, rho2] = atmosisa(0);
VDash = V2 * 3.28084 * MachNum; %Convered back to ft/s

LOverDMax = 17;
LOverDCruise = 0.866 * LOverDMax;
LOverDLoiter = LOverDMax;
Range = 2.43e6; %feet
CCruise = 0.5 * (1/(60^2));
CLoiter = 0.4 *(1/(60^2));
WCrew = 0;
WFireRetardant = 9 * 8000; %lb (Density * vol)
WTot = WCrew + WFireRetardant;

LoiterOverTarget = 3600; %Seconds
LoiterOverAirport = 900; %Seconds

%takeoff
W01 = 0.98; %historical trends

%Climb to altitude
W12 = 0.97; %historical trends

%Cruise to the target
W23 = exp((-1 * Range * CCruise) / (VCruise * LOverDCruise)); %equation when going too target

%Desend to Sea level to drop payloads
W34 = 0.99; %historical trends

%Loiter over fire
W45 = exp((-1*LoiterOverTarget*CLoiter)/(LOverDLoiter)); %equation when loitering over target

%Dashing back to base
W56 = exp((-1 * Range * CCruise) / (VDash * LOverDCruise)); %Returning home

%Loiter above airfield
W67 = exp((-1*LoiterOverAirport*CLoiter)/(LOverDLoiter)); %equation when loitering over airfield

%land
W78 = 0.997; %historical trends

W80 = W01 * W12 * W23 * W34 * W45 * W56 * W67 * W78; %W8/W0


WfuelW0 = 1.06*(1 - W80); %Wfuel/W0 6 precent leftover for extra fuel and stuff


%because Wempty/W0 = A*K*(W0)^C
A = 0.93; %because droping fire retardant is like droping bombs, based on historical data
C = -0.07; %based on historical data
K = 1; %no variable sweep
W0Guess = input('Enter your guess in lb ');

%{
while(1)
    WeOverW0 = A*((W0Guess)^C)*K; %finding Wempty/W0
    WCalculated =  WTot/ (1-WfuelW0-WeOverW0);
    
    if(Difference(WCalculated,W0Guess) < 1) %ballpark esimate here
        
            fprintf("The value for TakeOff Weight is %i pounds", WCalculated);
        
        break
    else
        W0Guess = WCalculated;
    end
end


function diff = Difference(x,y)
    diff = abs(x-y);
end

%}


while(1)
    WemptyW0 = A*((W0Guess)^C)*K; %finding Wempty/W0
    WCalculated = WTot / (1-WfuelW0-WemptyW0);
    
    if(Difference(WCalculated,W0Guess) < 1) %ballpark esimate here
        
        fprintf("The value for TakeOff Weight is %i pounds", WCalculated);
        
        break
    else
        W0Guess = WCalculated;
    end
end


function diff = Difference(x,y)
    diff = abs(x-y);
end


