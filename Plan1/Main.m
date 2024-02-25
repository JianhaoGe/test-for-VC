%% This program is used to solve the model of Plan I, including 2 route train lines.
%% Line 1 presents the long-route train line of Shanghai Metro Line 3;
%% Line 2 presents the loop-route train line of Shanghai Metro Line 4.

%% Input （Values that need to be independently defined)

%% Value:
%% TrainCapacity -- The standard capacity of trains;
%% fullloadrate  -- The maximum allowable full load rate of a train;
%% M             -- A sufficiently large constant number;
%% MinD          -- Minimum dwelltime time coefficient;
%% MaxD          -- Maximum dwelltime time coefficient;
%% MinH          -- Minimum headway time of successive trains;
%% MaxH          -- Maximum headway time of successive trains;
%% MinVC         -- Minimum headway time of successive trains of different lines when they are virtual coupled;
%% MaxVC         -- Maximum headway time of successive trains of different lines when they are virtual coupled;
%% Totaltrain1   -- The total number of Line 1; 
%% Totalstation1 -- The total station number of Line 1;
%% Totaltrain2   -- The total number of Line 2;
%% Totalstation2 -- The total station number of Line 2;
%% Sharestation  -- The number of shared stations;
%% Starttime     -- The starting point of research time period;
%% Endtime       -- The ending point of research time period;
%% Note: Here, Totaltrain1 = Totaltrain2.

%% Matrix:
%% MinR1(Totalstation1-1,1)      -- The minimum running time of each section of Line 1;
%% MaxR1(Totalstation1-1,1)      -- The maximum running time of each section of Line 1;
%% Dwelltime1(Totalstation1,1)   -- The standard dwelltime of each station of Line 1;
%% MinR2(Totalstation2-1,1)      -- The minimum running time of each section of Line 2;
%% MaxR2(Totalstation2-1,1)      -- The maximum running time of each section of Line 2;
%% Dwelltime2(Totalstation2,1)   -- The standard dwelltime of each station of Line 2;
%% Line1(Totalstation1,1)        -- The station name of Line 1;
%% Line2(Totalstation2,1)        -- The station name of Line 2;
%% CommonStopSet(Sharestation,1) -- The station name of shared stations.

Cmax=fullloadrate*TrainCapacity; %Maximum train capacity
MinD1=Dwelltime1*MinD; %Calculate the minimum dwelltime at each station of Line 1
MaxD1=MinD1*MaxD; %Calculate the maximum dwelltime at each station of Line 1
MinD2=Dwelltime2*MinD; %Calculate the minimum dwelltime at each station of Line 2
MaxD2=MinD2*MaxD; %Calculate the maximum dwelltime at each station of Line 2

%% Variable Definitions
Arrival1=intvar(Totaltrain1,Totalstation1);
Departure1=intvar(Totaltrain1,Totalstation1);
Arrival2=intvar(Totaltrain2,Totalstation2);
Departure2=intvar(Totaltrain2,Totalstation2);

%% Timetabling constraints

[Runtime1MAX,ConRuntime1,Runtime1MIN]=MakeRuntimeContraints(Arrival1,Departure1,MinR1,MaxR1);
[Dwelltime1MAX,ConDwelltime1,Dwelltime1MIN]=MakeDwelltimeContraints(Arrival1,Departure1,MinD1,MaxD1);
[Runtime2MAX,ConRuntime2,Runtime2MIN]=MakeRuntimeContraints(Arrival2,Departure2,MinR2,MaxR2);
[Dwelltime2MAX,ConDwelltime2,Dwelltime2MIN]=MakeDwelltimeContraints(Arrival2,Departure2,MinD2,MaxD2);

%%Headway variables
%%Headway variables for trains of the same line
[Headway1MAX,ConHeadway1,Headway1MIN]=MakeSameHeadwayConstraints(Line1,Arrival1,Departure1,MinH,MaxH);
[Headway2MAX,ConHeadway2,Headway2MIN]=MakeSameHeadwayConstraints(Line2,Arrival2,Departure2,MinH,MaxH);

%%Headway variables for trains of different lines and general the VC variable
[Headway12MAX,ConHeadway12,Headway12MIN,VCor12,VCnot12]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line2,Arrival2,Departure2,MinH,MaxH,CommonStopSet2);

%%variables to form loop train services for Line2
%%Generate the connection matrix for loop train services
[arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink2,AllRunningtime2]=MakeLink(Arrival2);

%%Generate loop-route variables for Line2
[L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival2);

%%Constraints for timetabling
CTimetable=[

    %%Constraints for time period (Constraint 1-2)
    Arrival1>=Starttime;
    Departure1>=Starttime;
    Arrival2>=Starttime;
    Departure2>=Starttime;
    Departure1<=Endtime;
    Departure2<=Endtime;
    
    %%Constraints for running time and dwell time (Constraint 3-4)
    Runtime1MIN<=ConRuntime1;
    ConRuntime1<=Runtime1MAX;
    Dwelltime1MIN<=ConDwelltime1;
    ConDwelltime1<=Dwelltime1MAX;
    Runtime2MIN<=ConRuntime2;
    ConRuntime2<=Runtime2MAX;
    Dwelltime2MIN<=ConDwelltime2;
    ConDwelltime2<=Dwelltime2MAX;
    
    %%Constraints for train headway (Constraint 2)
    Headway1MIN<=ConHeadway1;
    ConHeadway1<=Headway1MAX;
    Headway2MIN<=ConHeadway2;
    ConHeadway2<=Headway2MAX;
    
    %%Constraints for VC headway (Constraint 9-13)
    Headway12MIN.*VCor12All+MinVC.*VCnot12All<=ConHeadway12;
    ConHeadway12<=Headway12MAX.*VCor12All+MaxVC.*VCnot12All;
    VCor12(:,1)+VCor12(:,2)>=ones(Totaltrain1,1); %% Trains that do not undergo virtual coupling are allowed.
    VCor12+VCnot12==ones(Totaltrain1,2);
    
    %%Constraints for loop-route train services (Constraint 6-8)
    arf1left<=arf1;
    arf1<=arf1right;
    arf2left<=arf2;
    arf2<=arf2right;
    arf3left<=arf3;
    arf3<=arf3right;
    L1min<=L1;
    L1<=L1max;
    sum(arf3(1,:))==1;
    sum(arf3(2,:))==1;
    sum(arf3(3,:))==1;
    sum(arf3(4,:))==1;
    sum(arf3(2,:))==1;
    sum(arf3(6,:))==1;%%N_L^min=6 in constraint 8
    ];
disp("Timetabling constraints finished");

%% Passenger assignment constraints
%%Passenger data input
STime=Starttime;
ETime=11*3600;
Timestamp=300;
load('PassengerDown.mat');
bs=1;%%magnification rate. In this paper, we use 1 and 1.2 times to test the model.
%%ArrivalRate, each dimension separately represents passengers' origin station and its arrival time period (divided every 300 seconds)
ArrivalRate1=ArrivalRate1*bs; %%ArrivalRate1 represents those passengers who can only take Shanghai Metro Line3 and can take long-route train lines
ArrivalRate3=ArrivalRate3*bs; %%ArrivalRate3 represents those passengers who can only take Shanghai Metro Line3 and can take short-route train lines
ArrivalRate2=ArrivalRate2*bs; %%ArrivalRate2 represents those passengers who can only take Shanghai Metro Line4
ArrivalRateShare=ArrivalRateShare*bs; %%ArrivalRateShare represents those passengers who can both take Shanghai Metro Line3 and Line4, which is only occur in the sharing-corridor.
%%ArrivalRate, each dimension separately represents passengers' origin station, destination station and its arrival time period (divided every 300 seconds)
AlightRate1=AlightRate1*bs; %%AlightRate1 represents those passengers who can only take Shanghai Metro Line3 and can take long-route train lines
AlightRate3=AlightRate3*bs; %%AlightRate3 represents those passengers who can only take Shanghai Metro Line3 and can take short-route train lines
AlightRate2=AlightRate2*bs; %%AlightRate2 represents those passengers who can only take Shanghai Metro Line4
AlightRateShare=AlightRateShare*bs; %%AlightRateShare represents those passengers who can both take Shanghai Metro Line3 and Line4, which is only occur in the sharing-corridor.

%%%Initialization for variables of passenger assignment
Cremain_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qboard_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qinvehicle_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qstranded_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qwait_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
QArrival_Line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qalight_line1_left=sdpvar(Totaltrain1,Totalstation1);

Cremain_line2_left=sdpvar(Totaltrain2,Totalstation2);
Qboard_line2_left=sdpvar(Totaltrain2,Totalstation2-1);
Qinvehicle_line2_left=sdpvar(Totaltrain2,Totalstation2);
Qstranded_line2_left=sdpvar(Totaltrain2,Totalstation2-1);
Qwait_line2_left=sdpvar(Totaltrain2,Totalstation2-1);
QArrival_Line2_left=sdpvar(Totaltrain2,Totalstation2-1);
Qalight_line2_left=sdpvar(Totaltrain2,Totalstation2);

%%Timestamp modelling (To make every train departure time into one time period)
%%eg. If the departure time of train A is 7:08 a.m.,the variable which represents its departure within 7:02-7:10a.m. will equal 1 and other variables will equal 0. 

[X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval2(Departure1,STime,ETime,Timestamp);
[X3_Line2,X3left_Line2,X3right_Line2] = GetTimeInterval2(Departure2,STime,ETime,Timestamp);

disp("Timestamp modelling finished");

%%Generate Arrival passengers£¨Including two categories£ºThose who only can take Line1 or Line2; Those who can take both Line1 and Line2£©
[Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line2,Z1_Line2MIN,Z1_Line2MAX,Z2_Line2,Z2_Line2MIN,Z2_Line2MAX,QArrival_Line1,QArrival_Line2]=MakeOnlyArrival(ArrivalRate1,ArrivalRate2,X3_Line1,X3_Line2,Departure1,Departure2,ETime,STime,Timestamp);
[Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line2,Z3_Line2MIN,Z3_Line2MAX,Z4_Line2,Z4_Line2MIN,Z4_Line2MAX,Z2_Line2,Z2_Line2MIN,Z2_Line2MAX,Z6_Line2,Z6_Line2MIN,Z6_Line2MAX,Z7_Line2,Z7_Line2MIN,Z7_Line2MAX,Z8_Line2,Z8_Line2MIN,Z8_Line2MAX,QArrival_Line1,QArrival_Line2]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line2,X3_Line1,X3_Line2,Departure1,Departure2,ETime,STime,Timestamp,VCor12);
disp("Arrival passengers finished");
%%Generate remaining capacity
Cremain_line1_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line1_left);
Cremain_line2_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line2_left);
disp("Remaining capacity finished");
%%Generate boarding passengers
Qboard_line1_right = MakeBoard(Qwait_line1_left,Cremain_line1_left);
Qboard_line2_right = MakeBoard(Qwait_line2_left,Cremain_line2_left);
disp("Boarding passengers finished");
%%Generate in-vehicle passengers
Qinvehicle_line1_right = Makeinvehicle(Qboard_line1_left,Qalight_line1_left);
[Qinvehicle_line2_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicle2(Qboard_line2_left,Qalight_line2_left,arf3);
disp("In-vehicle passengers finished");
%%Generate stranded passengers
Qstranded_line1_right = Makestranded(Qwait_line1_left,Qboard_line1_left);
Qstranded_line2_right = Makestranded(Qwait_line2_left,Qboard_line2_left);
disp("Stranded passengers finished");
%%Generate waiting passengers
Qwait_line1_right = Makewait(QArrival_Line1_left,Qstranded_line1_left);
Qwait_line2_right = Makewait(QArrival_Line2_left,Qstranded_line2_left);
disp("Waiting passengers finished");
%%Generate alighting passengers
[Qalight_Line1_right,Qalight_Line2_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure2,Qboard_line2_left,Rate2,arf3);
disp("Alighting passengers finished");

%%Constraints for passenger assignment
CTimestamp=[sum(X3_Line1,2)==ones(Totaltrain1*(Totalstation1-1),1);
    sum(X3_Line2,2)==ones(Totaltrain2*(Totalstation2-1),1);
    X3left_Line1+0.01<=Departure1(:,1:end-1)-STime;
    Departure1(:,1:end-1)-STime<=X3right_Line1;
    X3left_Line2+0.01<=Departure2(:,1:end-1)-STime;
    Departure2(:,1:end-1)-STime<=X3right_Line2;];
CArrival=[Z1_Line1MIN<=Z1_Line1;
    Z1_Line1<=Z1_Line1MAX;
    Z1_Line2MIN<=Z1_Line2;
    Z1_Line2<=Z1_Line2MAX;
    Z2_Line1MIN<=Z2_Line1;
    Z2_Line1<=Z2_Line1MAX;
    Z2_Line2MIN<=Z2_Line2;
    Z2_Line2<=Z2_Line2MAX;
    Z3_Line1MIN<=Z3_Line1;
    Z3_Line1<=Z3_Line1MAX;
    Z3_Line2MIN<=Z3_Line2;
    Z3_Line2<=Z3_Line2MAX;
    Z4_Line1MIN<=Z4_Line1;
    Z4_Line1<=Z4_Line1MAX;
    Z4_Line2MIN<=Z4_Line2;
    Z4_Line2<=Z4_Line2MAX;
    Z2_Line1MIN<=Z2_Line1;
    Z2_Line1<=Z2_Line1MAX;
    Z2_Line2MIN<=Z2_Line2;
    Z2_Line2<=Z2_Line2MAX;
    Z6_Line1MIN<=Z6_Line1;
    Z6_Line1<=Z6_Line1MAX;
    Z6_Line2MIN<=Z6_Line2;
    Z6_Line2<=Z6_Line2MAX;
    Z7_Line1MIN<=Z7_Line1;
    Z7_Line2MIN<=Z7_Line2;
    Z7_Line2<=Z7_Line2MAX;
    Z8_Line1MIN<=Z8_Line1;
    Z8_Line1<=Z8_Line1MAX;
    Z8_Line2MIN<=Z8_Line2;
    Z8_Line2<=Z8_Line2MAX;
    QArrival_Line1_left==QArrival_Line1;
    QArrival_Line2_left==QArrival_Line2;];
Calight=[Qalight_line1_left==Qalight_Line1_right;
    Qalight_line2_left==Qalight_Line2_right;
    ZZ3min<=ZZ3;
    ZZ3<=ZZ3max;
    ZZ4min<=ZZ4
    ZZ4<=ZZ4max;];
CCremain=[Cremain_line1_left==Cremain_line1_right;
    Cremain_line2_left==Cremain_line2_right;];
Cboard=[
    Qboard_line1_left<=Qwait_line1_left;
    Qboard_line2_left<=Qwait_line2_left;
    Qboard_line1_left<=Cremain_line1_left(:,1:Totalstation1-1);
    Qboard_line2_left<=Cremain_line2_left(:,1:Totalstation2-1);
    Qboard_line1_left>=0;
    Qboard_line2_left>=0;
    ];
Cinvehicle=[Qinvehicle_line1_left==Qinvehicle_line1_right;
    Qinvehicle_line2_left==Qinvehicle_line2_right;
    ZZ1min<=ZZ1;
    ZZ1<=ZZ1max;
    ZZ2min<=ZZ2;
    ZZ2<=ZZ2max;];
Cstranded=[Qstranded_line1_left==Qstranded_line1_right;
    Qstranded_line2_left==Qstranded_line2_right;];
Cwait=[Qwait_line1_left==Qwait_line1_right;
    Qwait_line2_left==Qwait_line2_right;];
disp("Constraints for passenger assignment finished");

%% Objective function
C=[
    CTimetable;
    CTimestamp;
    CArrival;
    Calight;
    CCremain;
    Cboard;
    Cinvehicle;
    Cstranded;
    Cwait;
    ];

obj=sum(sum(Qstranded_line1_left))+sum(sum(Qstranded_line2_left));
ops = sdpsettings('solver','gurobi');
result=solvesdp(C,obj,ops);

%% Display
Display;

%% Save
Qalight_line1_left=double(Qalight_line1_left);
Qalight_line2_left=double(Qalight_line2_left);
QArrival_Line1_left=double(QArrival_Line1_left);
QArrival_Line2_left=double(QArrival_Line2_left);
Qboard_line1_left=double(Qboard_line1_left);
Qboard_line2_left=double(Qboard_line2_left);
Qinvehicle_line1_left=double(Qinvehicle_line1_left);
Qinvehicle_line2_left=double(Qinvehicle_line2_left);
Qstranded_line1_left=double(Qstranded_line1_left);
Qstranded_line2_left=double(Qstranded_line2_left);
Qwait_line1_left=double(Qwait_line1_left);
Qwait_line2_left=double(Qwait_line2_left);
Cremain_line1_left=double(Cremain_line1_left);
Cremain_line2_left=double(Cremain_line2_left);
Departure1=double(Departure1);
Departure2=double(Departure2);
Arrival1=double(Arrival1);
Arrival2=double(Arrival2);
arf3=double(arf3);
VCor12=double(VCor12);

save result2 Qalight_line1_left Qalight_line2_left QArrival_Line1_left QArrival_Line2_left Qboard_line1_left Qboard_line2_left Qinvehicle_line1_left Qinvehicle_line2_left Qwait_line1_left Qwait_line2_left Cremain_line1_left Cremain_line2_left Departure1 Departure2 Arrival1 Arrival2 arf3 VCor12 Qstranded_line1_left Qstranded_line2_left




