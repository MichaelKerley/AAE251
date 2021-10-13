%AAE 251 Fall 2021
%Homework <HW2>
%Atmosphere Matlab Problem
%Authors: <Michael Kerley>

%metric on right Imperial on left
Table33Cruise = [25.5 0.9; 22.7 0.8;14.1 0.5];
Table33Loiter = [22.7 -1.2; 19.8 0.7;11.3 0.4];

Table34Cruise = [0.4 0.068; 0.4 0.068; 0.5 0.085];
Table34Loiter = [0.5 0.085; 0.5 0.085; 0.6 0.101];

answer = questdlg('What type of units will you be using?', 'Unit Selection','Metric','Imperial','Quit','Quit');
switch answer
    case 'Metric'
        Units = 1;
    case 'Imperial'
        Units = 2;
    case 'No thank you'
        disp('restart??')
end

if(Units == 1)
    Range = str2double(inputdlg("Range in kilometers")) * 3280.84; %Converts from kilometers to feet
    PayloadW = str2double(inputdlg("Payload in kilograms (includes passangers and crew)")) * 2.20462; %pounds
    CrusingAltitude = str2double(inputdlg("Crusing Altitude in meters")); %stays in Meters
    [T, speedOfSound, P, rho] = atmosisa(CrusingAltitude);
    CrusingSpeed = str2double(inputdlg("Crusing Speed Im Mach Number")) * speedOfSound * (3.28084); %converts to ft/s
end

if(Units == 2)
    Range = str2double(inputdlg("Range in Nautical miles")) * 6076.1; %converts to feet
    PayloadW = str2double(inputdlg("Payload in pounds (includes passangers and crew)")); %pounds
    CrusingAltitude = str2double(inputdlg("Cruising Altitude in feet")); %metric meters. imperal feet
    Temporary = (CrusingAltitude/3.28084);
    
    [T, speedOfSound, P, rho] = atmosisa(Temporary); %because atmosisa only does metric units
    CrusingSpeed = str2double(inputdlg("Cruising Speed In Mach Number")) * speedOfSound * (3.28084); %converts to ft/s
end



EnduranceTarget = str2double(inputdlg("Loiter time over target in hours")) * 3600; %converted to seconds
EnduranceLanding = str2double(inputdlg("Loiter time over airfield in hours")) * 3600; %converted to seconds
LiftDragMax = str2double(inputdlg("Lift drag ratio maxium")); 


answer2 = questdlg('what type of aircraft','select aircraft', 'Jet', 'Prop', 'Prop');
switch answer2
    case 'Jet'
        Type = 1;
    case 'Prop'
        Type = 2;
end

if (Type == 1)
    answer3 = questdlg('What type of engine?', 'EngineSelector', 'Pure TurboJet', 'Lowbypass Turbofan','HighbypassTurboFan','HighbypassTurboFan');
    switch answer3
        case 'Pure TurboJet'
            Engine = 1;
        case 'Lowbypass Turbofan'
            Engine = 2;
        case 'HighbypassTurboFan'
            Engine = 3;
    end
    Ccruise = Table33Cruise(Engine, 2) * (1/(60^2)); % Spefic fuel comsumption for cruising converted to 1/s
    Cloiter = Table33Loiter(Engine, 2) * (1/(60^2)); %Spefic fuel comsumption for loitering converted to 1/s
    LDRatioCruise = 0.866*LiftDragMax; %Page 27
    LDRatioLoiter = LiftDragMax; 
end


%takeoff
W01 = 0.97; %historical trends
%Climb
W12 = 0.985; %historical trends
%Cruise
W23 = exp((-1 * Range * Ccruise) / (CrusingSpeed * LDRatioCruise)); %equation when going too target
%Loiter
W34 = exp((-1*EnduranceTarget*Cloiter)/(LDRatioLoiter)); %equation when loitering over target

%Cruise again back to base
W45 = W23; %equation when coming home

%Loiter above airfield
W56 = exp((-1*EnduranceLanding*Cloiter)/(LDRatioLoiter)); %equation when loitering over airfield

%land
W67 = 0.995; %historical trends

W70 = W01 * W12 * W23 * W34 * W45 * W56 * W67;%W7/W0

WfuelW0 = 1.06*(1 - W70); %Wfuel/W0 6 precent leftover for extra fuel and stuff

%because Wempty/W0 = A*K*(W0)^C
A = 0.93; % A = input('Enter The value for A");
C = -0.07; % C = input('Enter Value For C');
K = 1; % K = input('Enter value for K');
if(Units == 1)
    W0Guess = input('Enter your guess in kg ') * 2.20462; %converts to lb
end
if(Units == 2)
    W0Guess = input('Enter your guess in lb ');
end

while(1)
    WemptyW0 = A*((W0Guess)^C)*K; %finding Wempty/W0
    WCalculated = PayloadW / (1-WfuelW0-WemptyW0);
    
    if(Difference(WCalculated,W0Guess) < 1) %ballpark esimate here
        if(Units == 2)
            fprintf("The value for TakeOff Weight is %i pounds", WCalculated);
        end
        if(Units == 1)
            fprintf("The value for TakeOff Weight is %i kg", (WCalculated * 0.453592));
        end
        
        break
    else
        W0Guess = WCalculated;
    end
end


function diff = Difference(x,y)
    diff = abs(x-y);
end






