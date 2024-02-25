clc;close all;clear all;
%% Initialization.
%%In this code, Line1 presents the long-route train line of Shanghai Metro Line3;
%%Line 5 presents the loop-route train line of Shanghai Metro Line4;
TrainCapacity=340*6;
fullloadrate=1.2;%Maximum allowable full load rate is 120%
Cmax=fullloadrate*TrainCapacity;%Maximum train capacity

M=99999;


load('Runningtime.mat');%Loading runningtime data
load('Dwelltime.mat');%Loading dwelltime data
MinD=1;%Minimum dwelltime time coefficient
MaxD=1.2;%Maximum dwelltime time coefficient
MinH=120;%Minimum headway time of successive trains (seconds)
MaxH=300;%Maximum headway time of successive trains (seconds)

MinVC=30;%Minimum headway time of successive trains of different lines when they are virtual coupled (seconds)

%Initialization of Line1: long-route train line of Shanghai Metro Line3;
Line1=Runningtime(Runningtime.Planning==1,:);%Select stations of Line1
Totaltrain1=20;%Define the total train number of Line1
Totalstation1=length(Line1.ID)+1;%Calculate the total station number of Line1
MinR1=fix(Line1.Time)*60+mod(Line1.Time*100,100);%Calculate the minimum running time of each section of Line1 (seconds)
MaxR1=MinR1*1.2;%Calculate the maximum running time of each section of Line1 (seconds)
Dwelltime1=Dwelltime(Dwelltime.Planning==1,:);%Select train dwelltime of Line1
MinD1=Dwelltime1.Time*100*MinD;%Calculate the minimum dwelltime at each station of Line 1
MaxD1=MinD1*MaxD;%Calculate the maximum dwelltime at each station of Line 1

%Initialization of Line5: loop-route train line of Shanghai Metro Line4;
Line5=Runningtime(Runningtime.Planning==5,:);%Select stations of Line5
Totaltrain5=20;%Define the total train number of Line5
Totalstation5=length(Line5.ID)+1;%Calculate the total station number of Line5
MinR5=fix(Line5.Time)*60+mod(Line5.Time*100,100);%Calculate the minimum running time of each section of Line5 (seconds)
MaxR5=MinR5*1.2;%Calculate the maximum running time of each section of Line5 (seconds)
Dwelltime5=Dwelltime(Dwelltime.Planning==5,:);%Select train dwelltime of Line5
MinD5=Dwelltime5.Time*100*MinD;%Calculate the minimum dwelltime at each station of Line 5
MaxD5=MinD5*MaxD;%Calculate the maximum dwelltime at each station of Line 5

%%Determine the collinear stations of Line1 and Line5
CommonStopSet2=Line1.From(16:24);

%% Timetabling constraints
%%Initialization of ariival and departure time of Line1 and Line5
Arrival1=intvar(Totaltrain1,Totalstation1);
Departure1=intvar(Totaltrain1,Totalstation1);
Arrival5=intvar(Totaltrain5,Totalstation5);
Departure5=intvar(Totaltrain5,Totalstation5);

%%Runningtime and Dwelltime variables for Line1 and Line5
[Runtime1MAX,ConRuntime1,Runtime1MIN]=MakeRuntimeContraints(Arrival1,Departure1,MinR1,MaxR1);
[Dwelltime1MAX,ConDwelltime1,Dwelltime1MIN]=MakeDwelltimeContraints(Arrival1,Departure1,MinD1,MaxD1);
[Runtime5MAX,ConRuntime5,Runtime5MIN]=MakeRuntimeContraints(Arrival5,Departure5,MinR5,MaxR5);
[Dwelltime5MAX,ConDwelltime5,Dwelltime5MIN]=MakeDwelltimeContraints(Arrival5,Departure5,MinD5,MaxD5);

%%Headway variables
%%Headway variables for trains of the same line
[Headway1MAX,ConHeadway1,Headway1MIN]=MakeSameHeadwayConstraints(Line1,Arrival1,Departure1,MinH,MaxH);
[Headway5MAX,ConHeadway5,Headway5MIN]=MakeSameHeadwayConstraints(Line5,Arrival5,Departure5,MinH,MaxH);
%%Headway variables for trains of different lines and general the VC valuable
[Headway15MAX,ConHeadway15,Headway15MIN,VCor15]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line5,Arrival5,Departure5,MinH,MaxH,CommonStopSet2);
VCnot15=binvar(Totaltrain5,2);

%%variables to form loop train services for Line5
%%Generate the connection matrix for loop train services
[arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink5,AllRunningtime5]=MakeLink(Arrival5);
%%Generate loop-route variables for Line5
[L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival5);

disp("Timetabling related valuables generated");
%%Constraints for timetabling
CTimetable=[
    %%Constraints for time horizon (Constraint 1-2)
    Arrival1(1,1)==7*3600;
    Arrival1>=7*3600;
    Departure1>=7*3600;
    Arrival5>=7*3600;
    Departure5>=7*3600;
    Departure5<=10*3600;
    Departure1<=10*3600;
    %%Constraints for Running time and dwell time (Constraint 3-4)
    Runtime1MIN<=ConRuntime1;
    ConRuntime1<=Runtime1MAX;
    Dwelltime1MIN<=ConDwelltime1;
    ConDwelltime1<=Dwelltime1MAX;
    Runtime5MIN<=ConRuntime5;
    ConRuntime5<=Runtime5MAX;
    Dwelltime5MIN<=ConDwelltime5;
    ConDwelltime5<=Dwelltime5MAX;
    %%Constraints for train headway (Constraint 5)
    Headway1MIN<=ConHeadway1;
    ConHeadway1<=2*Headway1MAX;
    Headway5MIN<=ConHeadway5;
    ConHeadway5<=Headway5MAX;
    %%Constraints for VC headway (Constraint 9-13)
    Headway15MIN.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15]<=ConHeadway15;
    ConHeadway15<=Headway15MAX.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15];
    VCor15(:,1)+VCor15(:,2)>=ones(Totaltrain1,1);
    VCor15+VCnot15==ones(Totaltrain1,2);
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
    sum(arf3(5,:))==1;
    sum(arf3(6,:))==1;%%N_L^min=6 in constraint 8
    ];
disp("Timetabling constraints finished");

%% Passenger assignment constraints
%%Passenger data input
STime=7*3600;
ETime=11*3600;
Timestamp=300;
load('PassengerDown.mat');
bs=1;%%magnification rate. In this paper, we use 1 and 1.5 times to test the model.
%%ArrivalRate, each dimension separately represents passengers' origin station and its arrival time period (divided every 300 seconds)
ArrivalRate1=ArrivalRate1*bs; %%ArrivalRate1 represents those passengers who can only take Shanghai Metro Line3 and can take long-route train lines
ArrivalRate3=ArrivalRate3*bs; %%ArrivalRate3 represents those passengers who can only take Shanghai Metro Line3 and can take short-route train lines
ArrivalRate5=ArrivalRate5*bs; %%ArrivalRate5 represents those passengers who can only take Shanghai Metro Line4
ArrivalRateShare=ArrivalRateShare*bs; %%ArrivalRateShare represents those passengers who can both take Shanghai Metro Line3 and Line4, which is only occur in the sharing-corridor.
%%ArrivalRate, each dimension separately represents passengers' origin station, destination station and its arrival time period (divided every 300 seconds)
AlightRate1=AlightRate1*bs; %%AlightRate1 represents those passengers who can only take Shanghai Metro Line3 and can take long-route train lines
AlightRate3=AlightRate3*bs; %%AlightRate3 represents those passengers who can only take Shanghai Metro Line3 and can take short-route train lines
AlightRate5=AlightRate5*bs; %%AlightRate5 represents those passengers who can only take Shanghai Metro Line4
AlightRateShare=AlightRateShare*bs; %%AlightRateShare represents those passengers who can both take Shanghai Metro Line3 and Line4, which is only occur in the sharing-corridor.

%%%Initialization for variables of passenger assignment
Cremain_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qboard_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qinvehicle_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qstranded_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qwait_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
QArrival_Line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qalight_line1_left=sdpvar(Totaltrain1,Totalstation1);

Cremain_line5_left=sdpvar(Totaltrain5,Totalstation5);
Qboard_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qinvehicle_line5_left=sdpvar(Totaltrain5,Totalstation5);
Qstranded_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qwait_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
QArrival_Line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qalight_line5_left=sdpvar(Totaltrain5,Totalstation5);

%%Timestamp modelling (To make every train departure time into one time period)
%%eg. If the departure time of train A is 7:08 a.m.,the variable which represents its departure within 7:05-7:10a.m. will equal 1 and other variables will equal 0. 

[X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval2(Departure1,STime,ETime,Timestamp);
[X3_Line5,X3left_Line5,X3right_Line5] = GetTimeInterval2(Departure5,STime,ETime,Timestamp);

disp("Timestamp modelling finished");

%%Generate Arrival passengers£¨Including two categories£ºThose who only can take Line1 or Line5; Those who can take both Line1 and Line5£©
[Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line5]=MakeOnlyArrival(ArrivalRate1,ArrivalRate5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp);
[Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line5,Z3_Line5MIN,Z3_Line5MAX,Z4_Line5,Z4_Line5MIN,Z4_Line5MAX,Z5_Line5,Z5_Line5MIN,Z5_Line5MAX,Z6_Line5,Z6_Line5MIN,Z6_Line5MAX,Z7_Line5,Z7_Line5MIN,Z7_Line5MAX,Z8_Line5,Z8_Line5MIN,Z8_Line5MAX,QArrival_Line1,QArrival_Line5]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp,VCor15);
disp("Arrival passengers finished");
%%Generate remaining capacity
Cremain_line1_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line1_left);
Cremain_line5_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line5_left);
disp("Remaining capacity finished");
%%Generate boarding passengers
Qboard_line1_right = MakeBoard(Qwait_line1_left,Cremain_line1_left);
Qboard_line5_right = MakeBoard(Qwait_line5_left,Cremain_line5_left);
disp("Boarding passengers finished");
%%Generate in-vehicle passengers
Qinvehicle_line1_right = Makeinvehicle(Qboard_line1_left,Qalight_line1_left);
[Qinvehicle_line5_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicle5(Qboard_line5_left,Qalight_line5_left,arf3);
disp("In-vehicle passengers finished");
%%Generate stranded passengers
Qstranded_line1_right = Makestranded(Qwait_line1_left,Qboard_line1_left);
Qstranded_line5_right = Makestranded(Qwait_line5_left,Qboard_line5_left);
disp("Stranded passengers finished");
%%Generate waiting passengers
Qwait_line1_right = Makewait(QArrival_Line1_left,Qstranded_line1_left);
Qwait_line5_right = Makewait(QArrival_Line5_left,Qstranded_line5_left);
disp("Waiting passengers finished");
%%Generate alighting passengers
[Qalight_Line1_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure5,Qboard_line5_left,Rate5,arf3);
disp("Alighting passengers finished");

%%Constraints for passenger assignment
CTimestamp=[sum(X3_Line1,2)==ones(Totaltrain1*(Totalstation1-1),1);
    sum(X3_Line5,2)==ones(Totaltrain5*(Totalstation5-1),1);
    X3left_Line1+0.01<=Departure1(:,1:end-1)-STime;
    Departure1(:,1:end-1)-STime<=X3right_Line1;
    X3left_Line5+0.01<=Departure5(:,1:end-1)-STime;
    Departure5(:,1:end-1)-STime<=X3right_Line5;];
CArrival=[Z1_Line1MIN<=Z1_Line1;
    Z1_Line1<=Z1_Line1MAX;
    Z1_Line5MIN<=Z1_Line5;
    Z1_Line5<=Z1_Line5MAX;
    Z2_Line1MIN<=Z2_Line1;
    Z2_Line1<=Z2_Line1MAX;
    Z2_Line5MIN<=Z2_Line5;
    Z2_Line5<=Z2_Line5MAX;
    Z3_Line1MIN<=Z3_Line1;
    Z3_Line1<=Z3_Line1MAX;
    Z3_Line5MIN<=Z3_Line5;
    Z3_Line5<=Z3_Line5MAX;
    Z4_Line1MIN<=Z4_Line1;
    Z4_Line1<=Z4_Line1MAX;
    Z4_Line5MIN<=Z4_Line5;
    Z4_Line5<=Z4_Line5MAX;
    Z5_Line1MIN<=Z5_Line1;
    Z5_Line1<=Z5_Line1MAX;
    Z5_Line5MIN<=Z5_Line5;
    Z5_Line5<=Z5_Line5MAX;
    Z6_Line1MIN<=Z6_Line1;
    Z6_Line1<=Z6_Line1MAX;
    Z6_Line5MIN<=Z6_Line5;
    Z6_Line5<=Z6_Line5MAX;
    Z7_Line1MIN<=Z7_Line1;
    Z7_Line5MIN<=Z7_Line5;
    Z7_Line5<=Z7_Line5MAX;
    Z8_Line1MIN<=Z8_Line1;
    Z8_Line1<=Z8_Line1MAX;
    Z8_Line5MIN<=Z8_Line5;
    Z8_Line5<=Z8_Line5MAX;
    QArrival_Line1_left==QArrival_Line1;
    QArrival_Line5_left==QArrival_Line5;];
Calight=[Qalight_line1_left==Qalight_Line1_right;
    Qalight_line5_left==Qalight_Line5_right;
    ZZ3min<=ZZ3;
    ZZ3<=ZZ3max;
    ZZ4min<=ZZ4
    ZZ4<=ZZ4max;];
CCremain=[Cremain_line1_left==Cremain_line1_right;
    Cremain_line5_left==Cremain_line5_right;];
Cboard=[
    Qboard_line1_left<=Qwait_line1_left;
    Qboard_line5_left<=Qwait_line5_left;
    Qboard_line1_left<=Cremain_line1_left(:,1:Totalstation1-1);
    Qboard_line5_left<=Cremain_line5_left(:,1:Totalstation5-1);
    Qboard_line1_left>=0;
    Qboard_line5_left>=0;
    ];
Cinvehicle=[Qinvehicle_line1_left==Qinvehicle_line1_right;
    Qinvehicle_line5_left==Qinvehicle_line5_right;
    ZZ1min<=ZZ1;
    ZZ1<=ZZ1max;
    ZZ2min<=ZZ2;
    ZZ2<=ZZ2max;];
Cstranded=[Qstranded_line1_left==Qstranded_line1_right;
    Qstranded_line5_left==Qstranded_line5_right;];
Cwait=[Qwait_line1_left==Qwait_line1_right;
    Qwait_line5_left==Qwait_line5_right;];
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

obj=sum(sum(Qstranded_line1_left))+sum(sum(Qstranded_line5_left));
ops = sdpsettings('solver','gurobi');
result=solvesdp(C,obj,ops);

%% Display
Display;

%% Save
Qalight_line1_left=double(Qalight_line1_left);
Qalight_line5_left=double(Qalight_line5_left);
QArrival_Line1_left=double(QArrival_Line1_left);
QArrival_Line5_left=double(QArrival_Line5_left);
Qboard_line1_left=double(Qboard_line1_left);
Qboard_line5_left=double(Qboard_line5_left);
Qinvehicle_line1_left=double(Qinvehicle_line1_left);
Qinvehicle_line5_left=double(Qinvehicle_line5_left);
Qstranded_line1_left=double(Qstranded_line1_left);
Qstranded_line5_left=double(Qstranded_line5_left);
Qwait_line1_left=double(Qwait_line1_left);
Qwait_line5_left=double(Qwait_line5_left);
Cremain_line1_left=double(Cremain_line1_left);
Cremain_line5_left=double(Cremain_line5_left);
Departure1=double(Departure1);
Departure5=double(Departure5);
Arrival1=double(Arrival1);
Arrival5=double(Arrival5);
arf3=double(arf3);
VCor15=double(VCor15);

save result2 Qalight_line1_left Qalight_line5_left QArrival_Line1_left QArrival_Line5_left Qboard_line1_left Qboard_line5_left Qinvehicle_line1_left Qinvehicle_line5_left Qwait_line1_left Qwait_line5_left Cremain_line1_left Cremain_line5_left Departure1 Departure5 Arrival1 Arrival5 arf3 VCor15 Qstranded_line1_left Qstranded_line5_left




