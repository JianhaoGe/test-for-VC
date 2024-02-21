% clc;close all;clear all;
%%��ʼ����·������ݣ�Line1Ϊ�����߳���·��Line3Ϊ�����߶̽�·��Line5Ϊ�ĺ��߻���
TrainCapacity=340*6;%�г���Ա
fullloadrate=1.2;%�г�������
Cmax=fullloadrate*TrainCapacity;%�г���������

M=99999;


load('Runningtime.mat');
load('Dwelltime.mat');
MinD=1;%��Сͣ��ʱ��ϵ��
MaxD=1.2;%���ͣ��ʱ��ϵ��
MinH=120;%��С�������
MaxH=300;%��󷢳����

MinVC=30;%��С������鷢�����

%�����߳���·
Line1=Runningtime(Runningtime.Planning==1,:);%��վ��ȡ
Totaltrain1=10;%��������
Totalstation1=length(Line1.ID)+1;%��վ��
MinR1=fix(Line1.Time)*60+mod(Line1.Time*100,100);%��С��������ʱ��
MaxR1=MinR1*1.2;%�����������ʱ��
Dwelltime1=Dwelltime(Dwelltime.Planning==1,:);%ͣվʱ����ȡ
MinD1=Dwelltime1.Time*100*MinD;%��Сͣվʱ��
MaxD1=MinD1*MaxD;%���ͣվʱ��

%�����߶̽�·
Line3=Runningtime(Runningtime.Planning==3,:);%��վ��ȡ
Totaltrain3=10;%��������
Totalstation3=length(Line3.ID)+1;%��վ��
MinR3=fix(Line3.Time)*60+mod(Line3.Time*100,100);%��С��������ʱ��
MaxR3=MinR3*1.2;%�����������ʱ��
Dwelltime3=Dwelltime(Dwelltime.Planning==3,:);%ͣվʱ����ȡ
MinD3=Dwelltime3.Time*100*MinD;%��Сͣվʱ��
MaxD3=MinD3*MaxD;%���ͣվʱ��
%�ĺ��߻���
Line5=Runningtime(Runningtime.Planning==5,:);%��վ��ȡ
Totaltrain5=20;%��������
Totalstation5=length(Line5.ID)+1;%��վ��
MinR5=fix(Line5.Time)*60+mod(Line5.Time*100,100);%��С��������ʱ��
MaxR5=MinR5*1.2;%�����������ʱ��
Dwelltime5=Dwelltime(Dwelltime.Planning==5,:);%ͣվʱ����ȡ
MinD5=Dwelltime5.Time*100*MinD;%��Сͣվʱ��
MaxD5=MinD5*MaxD;%���ͣվʱ��

%%ȷ������վ�����������ߴ�С��·���ĺ��߽�·���֣�
CommonStopSet1=Line1.From(9:28);%�����ߴ�С��·����վ
CommonStopSet2=Line1.From(16:24);%���ĺ��߹���վ
% 
% % Ss=[Line1.From(1:15);Line5.From(1:17);Line1.From(16:23);Line1.From(24:28);Line5.From(26)];%���յ�վ��ĳ�վ
% % 
% %%���ɱ�������ʱ�̼�����ʱ��
% Arrival1=intvar(Totaltrain1,Totalstation1);
% Departure1=intvar(Totaltrain1,Totalstation1);
% Arrival3=intvar(Totaltrain3,Totalstation3);
% Departure3=intvar(Totaltrain3,Totalstation3);
% Arrival5=intvar(Totaltrain5,Totalstation5);
% Departure5=intvar(Totaltrain5,Totalstation5);
% 
% %%������������Լ����ͣվԼ��
% [Runtime1MAX,ConRuntime1,Runtime1MIN]=MakeRuntimeContraints(Arrival1,Departure1,MinR1,MaxR1);
% [Dwelltime1MAX,ConDwelltime1,Dwelltime1MIN]=MakeDwelltimeContraints(Arrival1,Departure1,MinD1,MaxD1);
% [Runtime3MAX,ConRuntime3,Runtime3MIN]=MakeRuntimeContraints(Arrival3,Departure3,MinR3,MaxR3);
% [Dwelltime3MAX,ConDwelltime3,Dwelltime3MIN]=MakeDwelltimeContraints(Arrival3,Departure3,MinD3,MaxD3);
% [Runtime5MAX,ConRuntime5,Runtime5MIN]=MakeRuntimeContraints(Arrival5,Departure5,MinR5,MaxR5);
% [Dwelltime5MAX,ConDwelltime5,Dwelltime5MIN]=MakeDwelltimeContraints(Arrival5,Departure5,MinD5,MaxD5);
% 
% %%���ɳ�ͷʱ��Լ������Ϊͬ��·�䳵ͷʱ�ࡢͬ�߲�ͬ��·��ͷʱ���벻ͬ�߳�ͷʱ�ࣩ
% %%�ڴ����ĺ��ߵĿ���˳���޶�Ϊ�������߳���·���ĺ��ߡ������߶̽�·���ĺ���
% %%ͬ��·�䳵ͷʱ��Լ��
% [Headway1MAX,ConHeadway1,Headway1MIN]=MakeSameHeadwayConstraints(Line1,Arrival1,Departure1,MinH,MaxH);
% [Headway3MAX,ConHeadway3,Headway3MIN]=MakeSameHeadwayConstraints(Line3,Arrival3,Departure3,MinH,MaxH);
% [Headway5MAX,ConHeadway5,Headway5MIN]=MakeSameHeadwayConstraints(Line5,Arrival5,Departure5,MinH,MaxH);
% %%ͬ�߲�ͬ��·��ͷʱ��Լ��
% [Headway13MAX,ConHeadway13,Headway13MIN]=MakeSameLineHeadwayConstraints(Line1,Arrival1,Departure1,Line3,Arrival3,Departure3,MinH,MaxH,CommonStopSet1);
% %%��ͬ�߳�ͷʱ��Լ�����������������߱�����
% [Headway15MAX,ConHeadway15,Headway15MIN,VCor15,Headway35MAX,ConHeadway35,Headway35MIN,VCor35]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line3,Arrival3,Departure3,Line5,Arrival5,Departure5,MinH,MaxH,CommonStopSet2);
% %%�����ĺ������ܾ���
% [arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink5,AllRunningtime5]=MakeLink(Arrival5);
% %%�����ĺ�������Լ��
% [L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival5);
% %%�������������߱��������ڿ���Լ����
% VCnot15=binvar(Totaltrain1,2);
% VCnot35=binvar(Totaltrain3,2);
% 
% disp("ʱ�̱�ģ���");
% %%ʱ�̱�Լ��
% CTimetable=[Arrival1(1,1)==7*3600;
%     Arrival1>=7*3600;
%     Departure1>=7*3600;
%     Arrival3>=7*3600;
%     Departure3>=7*3600;
%     Arrival5>=7*3600;
%     Departure5>=7*3600;
%     Departure5<=10*3600;
%     Departure3<=10*3600;
%     Departure1<=10*3600;
%     Runtime1MIN<=ConRuntime1;
%     ConRuntime1<=Runtime1MAX;
%     Dwelltime1MIN<=ConDwelltime1;
%     ConDwelltime1<=Dwelltime1MAX;
%     Runtime3MIN<=ConRuntime3;
%     ConRuntime3<=Runtime3MAX;
%     Dwelltime3MIN<=ConDwelltime3;
%     ConDwelltime3<=Dwelltime3MAX;
%     Runtime5MIN<=ConRuntime5;
%     ConRuntime5<=Runtime5MAX;
%     Dwelltime5MIN<=ConDwelltime5;
%     ConDwelltime5<=Dwelltime5MAX;
%     Headway1MIN<=ConHeadway1;
%     ConHeadway1<=2*Headway1MAX;
%     Headway3MIN<=ConHeadway3;
%     ConHeadway3<=2*Headway3MAX;
%     Headway5MIN<=ConHeadway5;
%     ConHeadway5<=Headway5MAX;
%     Headway13MIN<=ConHeadway13;
%     ConHeadway13<=Headway13MAX;
%     Headway15MIN.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15]<=ConHeadway15;
%     ConHeadway15<=Headway15MAX.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15];
%     Headway35MIN.*[VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35]+MinVC.*[VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35]<=ConHeadway35;
%     ConHeadway35<=Headway35MAX.*[VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35,VCor35]+MinVC.*[VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35,VCnot35];
%     VCor15(:,1)+VCor15(:,2)>=ones(Totaltrain1,1);
%     VCor35(:,1)+VCor35(:,2)>=ones(Totaltrain3,1);%VCor15ǰһ���ʾ1��󳵱��飬��һ���ʾ1��ǰ������
%     VCor15+VCnot15==ones(Totaltrain1,2);
%     VCor35+VCnot35==ones(Totaltrain1,2);
%     arf1left<=arf1;
%     arf1<=arf1right;
%     arf2left<=arf2;
%     arf2<=arf2right;
%     arf3left<=arf3;
%     arf3<=arf3right;
%     L1min<=L1;
%     L1<=L1max;
%     sum(arf3(1,:))==1;
%     sum(arf3(2,:))==1;
%     sum(arf3(3,:))==1;
%     sum(arf3(4,:))==1;
%     sum(arf3(5,:))==1;
%     sum(arf3(6,:))==1;
% %     sum(arf3(7,:))==1;
% %     sum(arf3(8,:))==1;
% %     sum(arf3(9,:))==1;
% %     sum(arf3(10,:))==1;%ǿ��Ҫ��ǰʮ���ĺ�������
%     ];
% disp("ʱ�̱�Լ�����");
%%����Լ������
%%������Ϣ����
STime=7*3600;
ETime=11*3600;
Timestamp=300;
load('PassengerDown2.mat');
% load('PassengerDown3.mat');
load('PassengerDown4.mat');
bs=1.5;
%����ʵ���ݳ���1.5��Ϊʵ������
ArrivalRate1=ArrivalRate1*bs;
ArrivalRate3=ArrivalRate3*bs;
ArrivalRate5=ArrivalRate5*bs;
ArrivalRateShare=ArrivalRateShare*bs;
AlightRate1=AlightRate1*bs;
AlightRate3=AlightRate3*bs;
AlightRate5=AlightRate5*bs;
AlightRateShare=AlightRateShare*bs;
%����������ʱ�̱����ڿ������ݵĲ��Բ���
% Arrival1=double(Arrival1);
% Arrival3=double(Arrival3);
% Arrival5=double(Arrival5);
% Departure1=double(Departure1);
% Departure3=double(Departure3);
% Departure5=double(Departure5);
% arf3=double(arf3);

%%%��ʼ����������
Cremain_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qboard_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qinvehicle_line1_left=sdpvar(Totaltrain1,Totalstation1);
Qstranded_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qwait_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
QArrival_Line1_left=sdpvar(Totaltrain1,Totalstation1-1);
Qalight_line1_left=sdpvar(Totaltrain1,Totalstation1);

Cremain_line3_left=sdpvar(Totaltrain3,Totalstation3);
Qboard_line3_left=sdpvar(Totaltrain3,Totalstation3-1);
Qinvehicle_line3_left=sdpvar(Totaltrain3,Totalstation3);
Qstranded_line3_left=sdpvar(Totaltrain3,Totalstation3-1);
Qwait_line3_left=sdpvar(Totaltrain3,Totalstation3-1);
QArrival_Line3_left=sdpvar(Totaltrain3,Totalstation3-1);
Qalight_line3_left=sdpvar(Totaltrain3,Totalstation3);

Cremain_line5_left=sdpvar(Totaltrain5,Totalstation5);
Qboard_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qinvehicle_line5_left=sdpvar(Totaltrain5,Totalstation5);
Qstranded_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qwait_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
QArrival_Line5_left=sdpvar(Totaltrain5,Totalstation5-1);
Qalight_line5_left=sdpvar(Totaltrain5,Totalstation5);

disp("�����������");
%%%ʱ�����ģ

% [X1_Line1,X1left_Line1,X1right_Line1,X2_Line1,X2left_Line1,X2right_Line1,X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval(Departure1,STime,ETime,Timestamp);
% [X1_Line3,X1left_Line3,X1right_Line3,X2_Line3,X2left_Line3,X2right_Line3,X3_Line3,X3left_Line3,X3right_Line3] = GetTimeInterval(Departure3,STime,ETime,Timestamp);
% [X1_Line5,X1left_Line5,X1right_Line5,X2_Line5,X2left_Line5,X2right_Line5,X3_Line5,X3left_Line5,X3right_Line5] = GetTimeInterval(Departure5,STime,ETime,Timestamp);

[X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval2(Departure1,STime,ETime,Timestamp);
[X3_Line3,X3left_Line3,X3right_Line3] = GetTimeInterval2(Departure3,STime,ETime,Timestamp);
[X3_Line5,X3left_Line5,X3right_Line5] = GetTimeInterval2(Departure5,STime,ETime,Timestamp);

disp("ʱ�����ģ���");

% [aamin,aamax,aa,Num1,Num3,Num5,Numall,AllDeparture]=MakeNum(Departure1,Departure3,Departure5,Line1,Line3,Line5,Ss);
% 
% [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line3,Z1_Line3MIN,Z1_Line3MAX,Z2_Line3,Z2_Line3MIN,Z2_Line3MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line1min,QArrival_Line1max,QArrival_Line3,QArrival_Line3min,QArrival_Line3max,QArrival_Line5,QArrival_Line5min,QArrival_Line5max]=MakeArrival(Num1,Num3,Num5,ArrivalRate1,ArrivalRate3,ArrivalRate5,AllDeparture,X3_Line1,X3_Line3,X3_Line5,ETime,STime,Timestamp);

%%%�����˿͵����Ϊֻ�ܳ���������/�ĺ��� �� ���߾��ɳ��� ���ֿ�����
[Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line3,Z1_Line3MIN,Z1_Line3MAX,Z2_Line3,Z2_Line3MIN,Z2_Line3MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line3,QArrival_Line5,QArrival11,QArrival31,QArrival51,Waittime11,Waittime31,Waittime51]=MakeOnlyArrival(ArrivalRate1,ArrivalRate3,ArrivalRate5,X3_Line1,X3_Line3,X3_Line5,Departure1,Departure3,Departure5,ETime,STime,Timestamp);
[Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line3,Z3_Line3MIN,Z3_Line3MAX,Z4_Line3,Z4_Line3MIN,Z4_Line3MAX,Z5_Line3,Z5_Line3MIN,Z5_Line3MAX,Z6_Line3,Z6_Line3MIN,Z6_Line3MAX,Z7_Line3,Z7_Line3MIN,Z7_Line3MAX,Z8_Line3,Z8_Line3MIN,Z8_Line3MAX,Z3_Line5,Z3_Line5MIN,Z3_Line5MAX,Z4_Line5,Z4_Line5MIN,Z4_Line5MAX,Z5_Line51,Z5_Line51MIN,Z5_Line51MAX,Z5_Line52,Z5_Line52MIN,Z5_Line52MAX,Z6_Line51,Z6_Line51MIN,Z6_Line51MAX,Z6_Line52,Z6_Line52MIN,Z6_Line52MAX,Z7_Line51,Z7_Line51MIN,Z7_Line51MAX,Z7_Line52,Z7_Line52MIN,Z7_Line52MAX,Z8_Line51,Z8_Line51MIN,Z8_Line51MAX,Z8_Line52,Z8_Line52MIN,Z8_Line52MAX,QArrival_Line1,QArrival_Line3,QArrival_Line5,QArrival12,QArrival32,QArrival52,Waittime12,Waittime32,Waittime52]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line3,QArrival_Line5,X3_Line1,X3_Line3,X3_Line5,Departure1,Departure3,Departure5,ETime,STime,Timestamp,VCor15,VCor35);
disp("�������ｨģ���");
%%%�г�������ģ
Cremain_line1_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line1_left);
Cremain_line3_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line3_left);
Cremain_line5_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line5_left);
disp("�г�������ģ���");
%%%�˿��ϳ���ģ
Qboard_line1_right = MakeBoard(Qwait_line1_left,Cremain_line1_left);
Qboard_line3_right = MakeBoard(Qwait_line3_left,Cremain_line3_left);
Qboard_line5_right = MakeBoard(Qwait_line5_left,Cremain_line5_left);
disp("�˿��ϳ���ģ���");
%%%�˿��ڳ���վ�ڣ���ģ��Qinvehicle��ʾ��ͣ��ĳһվ�¿������δ�Ͽ�ʱ�ĳ��ڳ˿�������
Qinvehicle_line1_right = Makeinvehicle(Qboard_line1_left,Qalight_line1_left);
Qinvehicle_line3_right = Makeinvehicle(Qboard_line3_left,Qalight_line3_left);
% Qinvehicle_line5_right = Makeinvehicle(Qboard_line5_left,Qalight_line5_left);
[Qinvehicle_line5_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicle5(Qboard_line5_left,Qalight_line5_left,arf3);
disp("�˿��ڳ���վ�ڣ���ģ���");
%%%�˿�������ģ
Qstranded_line1_right = Makestranded(Qwait_line1_left,Qboard_line1_left);%������Line3Line1��������
Qstranded_line3_right = Makestranded(Qwait_line3_left,Qboard_line3_left);
Qstranded_line5_right = Makestranded(Qwait_line5_left,Qboard_line5_left);
disp("�˿�������ģ���");
%%%�˿͵ȴ���ģ
% Qwait_line1_right = Makewait(QArrival_Line1_left,Qstranded_line1_left);%������Line3Line1��������
% Qwait_line3_right = Makewait(QArrival_Line3_left,Qstranded_line3_left);
[Qwait_line1_right,Qwait_line3_right] = Makewait13(QArrival_Line1_left,Qstranded_line1_left,QArrival_Line3_left,Qstranded_line3_left);
Qwait_line5_right = Makewait(QArrival_Line5_left,Qstranded_line5_left);
disp("�˿͵ȴ���ģ���");
%%%�˿��³���ģ
% [Qalight_Line1_right,Qalight_Line3_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max,Z9_Line1,Z9_Line1MIN,Z9_Line1MAX,Z9_Line3,Z9_Line3MIN,Z9_Line3MAX,Z9_Line5,Z9_Line5MIN,Z9_Line5MAX,Z10_Line1,Z10_Line1MIN,Z10_Line1MAX,Z10_Line3,Z10_Line3MIN,Z10_Line3MAX,Z10_Line5,Z10_Line5MIN,Z10_Line5MAX,XX5,XX5min,XX5max]=Makealight(Departure1,Qboard_line1_left,Alightpercent1,Departure3,Qboard_line3_left,Alightpercent3,Departure5,Qboard_line5_left,Alightpercent5,arf3,X3_Line1,X3_Line3,X3_Line5,ETime,STime,Timestamp);
% [Qalight_Line1_right,Qalight_Line3_right,Qalight_Line5_right]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure3,Qboard_line3_left,Rate3,Departure5,Qboard_line5_left,Rate5);
[Qalight_Line1_right,Qalight_Line3_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure3,Qboard_line3_left,Rate3,Departure5,Qboard_line5_left,Rate5,arf3);
disp("�˿��³���ģ���");

%����Լ��
% C2=[X1left_Line1<=X1_Line1;
%     X1_Line1<=X1right_Line1;
%     X2left_Line1<=X2_Line1;
%     X2_Line1<=X2right_Line1;
%     X3left_Line1<=X3_Line1;
%     X3_Line1<=X3right_Line1;
%     X1left_Line3<=X1_Line3;
%     X1_Line3<=X1right_Line3;
%     X2left_Line3<=X2_Line3;
%     X2_Line3<=X2right_Line3;
%     X3left_Line3<=X3_Line3;
%     X3_Line3<=X3right_Line3;
%     X1left_Line5<=X1_Line5;
%     X1_Line5<=X1right_Line5;
%     X2left_Line5<=X2_Line5;
%     X2_Line5<=X2right_Line5;
%     X3left_Line5<=X3_Line5;
%     X3_Line5<=X3right_Line5;
CTimestamp=[sum(X3_Line1,2)==ones(Totaltrain1*(Totalstation1-1),1);
    sum(X3_Line3,2)==ones(Totaltrain3*(Totalstation3-1),1);
    sum(X3_Line5,2)==ones(Totaltrain5*(Totalstation5-1),1);
    X3left_Line1+0.01<=Departure1(:,1:end-1)-STime;
    Departure1(:,1:end-1)-STime<=X3right_Line1;
    X3left_Line3+0.01<=Departure3(:,1:end-1)-STime;
    Departure3(:,1:end-1)-STime<=X3right_Line3;
    X3left_Line5+0.01<=Departure5(:,1:end-1)-STime;
    Departure5(:,1:end-1)-STime<=X3right_Line5;];
CArrival=[Z1_Line1MIN<=Z1_Line1;
    Z1_Line1<=Z1_Line1MAX;
    Z1_Line3MIN<=Z1_Line3;
    Z1_Line3<=Z1_Line3MAX;
    Z1_Line5MIN<=Z1_Line5;
    Z1_Line5<=Z1_Line5MAX;
    Z2_Line1MIN<=Z2_Line1;
    Z2_Line1<=Z2_Line1MAX;
    Z2_Line3MIN<=Z2_Line3;
    Z2_Line3<=Z2_Line3MAX;
    Z2_Line5MIN<=Z2_Line5;
    Z2_Line5<=Z2_Line5MAX;
    Z3_Line1MIN<=Z3_Line1;
    Z3_Line1<=Z3_Line1MAX;
    Z3_Line3MIN<=Z3_Line3;
    Z3_Line3<=Z3_Line3MAX;
    Z3_Line5MIN<=Z3_Line5;
    Z3_Line5<=Z3_Line5MAX;
    Z4_Line1MIN<=Z4_Line1;
    Z4_Line1<=Z4_Line1MAX;
    Z4_Line3MIN<=Z4_Line3;
    Z4_Line3<=Z4_Line3MAX;
    Z4_Line5MIN<=Z4_Line5;
    Z4_Line5<=Z4_Line5MAX;
    Z5_Line1MIN<=Z5_Line1;
    Z5_Line1<=Z5_Line1MAX;
    Z5_Line3MIN<=Z5_Line3;
    Z5_Line3<=Z5_Line3MAX;
    Z5_Line51MIN<=Z5_Line51;
    Z5_Line51<=Z5_Line51MAX;
    Z5_Line52MIN<=Z5_Line52;
    Z5_Line52<=Z5_Line52MAX;
    Z6_Line1MIN<=Z6_Line1;
    Z6_Line1<=Z6_Line1MAX;
    Z6_Line3MIN<=Z6_Line3;
    Z6_Line3<=Z6_Line3MAX;
    Z6_Line51MIN<=Z6_Line51;
    Z6_Line51<=Z6_Line51MAX;
    Z6_Line52MIN<=Z6_Line52;
    Z6_Line52<=Z6_Line52MAX;
    Z7_Line1MIN<=Z7_Line1;
    Z7_Line1<=Z7_Line1MAX;
    Z7_Line3MIN<=Z7_Line3;
    Z7_Line3<=Z7_Line3MAX;
    Z7_Line51MIN<=Z7_Line51;
    Z7_Line51<=Z7_Line51MAX;
    Z7_Line52MIN<=Z7_Line52;
    Z7_Line52<=Z7_Line52MAX;
    Z8_Line1MIN<=Z8_Line1;
    Z8_Line1<=Z8_Line1MAX;
    Z8_Line3MIN<=Z8_Line3;
    Z8_Line3<=Z8_Line3MAX;
    Z8_Line51MIN<=Z8_Line51;
    Z8_Line51<=Z8_Line51MAX;
    Z8_Line52MIN<=Z8_Line52;
    Z8_Line52<=Z8_Line52MAX;
    QArrival_Line1_left==QArrival_Line1;
    QArrival_Line3_left==QArrival_Line3;
    QArrival_Line5_left==QArrival_Line5;];
Calight=[Qalight_line1_left==Qalight_Line1_right;
    Qalight_line3_left==Qalight_Line3_right;
    Qalight_line5_left==Qalight_Line5_right;
    ZZ3min<=ZZ3;
    ZZ3<=ZZ3max;
    ZZ4min<=ZZ4
    ZZ4<=ZZ4max;];
CCremain=[Cremain_line1_left==Cremain_line1_right;
    Cremain_line3_left==Cremain_line3_right;
    Cremain_line5_left==Cremain_line5_right;];
Cboard=[
    Qboard_line1_left<=Qwait_line1_left;
    Qboard_line3_left<=Qwait_line3_left;
    Qboard_line5_left<=Qwait_line5_left;
    Qboard_line1_left<=Cremain_line1_left(:,1:Totalstation1-1);
    Qboard_line3_left<=Cremain_line3_left(:,1:Totalstation3-1);
    Qboard_line5_left<=Cremain_line5_left(:,1:Totalstation5-1);
    Qboard_line1_left>=0;
    Qboard_line3_left>=0;
    Qboard_line5_left>=0;
%     Qboard_line1_left==Qboard_line1_right;
%     Qboard_line3_left==Qboard_line3_right;
%     Qboard_line5_left==Qboard_line5_right;
    ];
Cinvehicle=[Qinvehicle_line1_left==Qinvehicle_line1_right;
    Qinvehicle_line3_left==Qinvehicle_line3_right;
    Qinvehicle_line5_left==Qinvehicle_line5_right;
    ZZ1min<=ZZ1;
    ZZ1<=ZZ1max;
    ZZ2min<=ZZ2;
    ZZ2<=ZZ2max;];
Cstranded=[Qstranded_line1_left==Qstranded_line1_right;
    Qstranded_line3_left==Qstranded_line3_right;
    Qstranded_line5_left==Qstranded_line5_right;];
Cwait=[Qwait_line1_left==Qwait_line1_right;
    Qwait_line3_left==Qwait_line3_right;
    Qwait_line5_left==Qwait_line5_right;];
%     Z9_Line1<=Z9_Line1MAX;
%     Z9_Line3MIN<=Z9_Line3;
%     Z9_Line3<=Z9_Line3MAX;
%     Z9_Line5MIN<=Z9_Line5;
%     Z9_Line5<=Z9_Line5MAX;
%     Z10_Line1MIN<=Z10_Line1;
%     Z10_Line1<=Z10_Line1MAX;
%     Z10_Line3MIN<=Z10_Line3;
%     Z10_Line3<=Z10_Line3MAX;
%     Z10_Line5MIN<=Z10_Line5;
%     Z10_Line5<=Z10_Line5MAX;
%     XX5min<=XX5;
%     XX5<=XX5max
%     ];
disp("����Լ�����");
C=[
%     CTimetable;
    CTimestamp;
    CArrival;
    Calight;
    CCremain;
    Cboard;
    Cinvehicle;
    Cstranded;
    Cwait;
    ];

% obj=-sum(sum(Qalight_Line1_right))-sum(sum(Qalight_Line3_right))-sum(sum(Qalight_Line5_right));
obj=sum(sum(Qstranded_line1_left))+sum(sum(Qstranded_line3_left))+sum(sum(Qstranded_line5_left));
% obj=(sum(sum(ConRuntime1))+sum(sum(ConRuntime3))+sum(sum(ConRuntime3)));
% obj=-sum(sum(arf3));
ops = sdpsettings('solver','gurobi');
result=solvesdp(C,obj,ops);

Display;
%����������
% cc15=double(ConHeadway15);
% cc35=double(ConHeadway35);
% cc13=double(ConHeadway13);
% d1=double(Departure1);
% d3=double(Departure3);
% d5=double(Departure5);
% a1=double(Arrival1);
% a3=double(Arrival3);
% a5=double(Arrival5);
% 
% 
% for i=1:Totaltrain1
%     a=29;
%     for j=1:28
%         x=[];
%         y=[];
%         x(1)=double(Arrival1(i,j));
%         y(1)=a;
%         x(2)=double(Departure1(i,j));
%         y(2)=a;
%         plot(x,y,'k');
%         hold on
%         x=[];
%         y=[];
%         x(1)=double(Departure1(i,j));
%         y(1)=a;
%         x(2)=double(Arrival1(i,j+1));
%         y(2)=a-1;
%         plot(x,y,'k');
%         hold on
%         a=a-1;
%     end
% end
% 
% for i=1:Totaltrain3
%     b=21;
%     for j=1:20
%         x=[];
%         y=[];
%         x(1)=double(Arrival3(i,j));
%         y(1)=b;
%         x(2)=double(Departure3(i,j));
%         y(2)=b;
%         plot(x,y,'k');
%         hold on
%         x=[];
%         y=[];
%         x(1)=double(Departure3(i,j));
%         y(1)=b;
%         x(2)=double(Arrival3(i,j+1));
%         y(2)=b-1;
%         plot(x,y,'k');
%         hold on
%         b=b-1;
%     end
% end
% 
% for i=1:Totaltrain5
%     c=47;
%     for j=1:17
%         x=[];
%         y=[];
%         x(1)=double(Arrival5(i,j));
%         y(1)=c;
%         x(2)=double(Departure5(i,j));
%         y(2)=c;
%         plot(x,y,'r');
%         hold on
%         x=[];
%         y=[];
%         x(1)=double(Departure5(i,j));
%         y(1)=c;
%         x(2)=double(Arrival5(i,j+1));
%         y(2)=c-1;
%         plot(x,y,'r');
%         hold on
%         c=c-1;
%     end
%     c=14;
%     for j=18:25
%         x=[];
%         y=[];
%         x(1)=double(Arrival5(i,j));
%         y(1)=c;
%         x(2)=double(Departure5(i,j));
%         y(2)=c;
%         plot(x,y,'r');
%         hold on
%         x=[];
%         y=[];
%         x(1)=double(Departure5(i,j));
%         y(1)=c;
%         x(2)=double(Arrival5(i,j+1));
%         y(2)=c-1;
%         plot(x,y,'r');
%         hold on
%         c=c-1;
%     end
%         x=[];
%         y=[];
%         x(1)=double(Arrival5(i,j+1));
%         y(1)=1;
%         x(2)=double(Departure5(i,j+1));
%         y(2)=1;
%         plot(x,y,'r');
%         hold on
%         x=[];
%         y=[];
%         x(1)=double(Departure5(i,j+1));
%         y(1)=1;
%         x(2)=double(Arrival5(i,j+2));
%         y(2)=0;
%         plot(x,y,'r');
%         hold on
% end
%         
Qalight_line1_left=double(Qalight_line1_left);
Qalight_line3_left=double(Qalight_line3_left);
Qalight_line5_left=double(Qalight_line5_left);
QArrival_Line1_left=double(QArrival_Line1_left);
QArrival_Line3_left=double(QArrival_Line3_left);
QArrival_Line5_left=double(QArrival_Line5_left);
Qboard_line1_left=double(Qboard_line1_left);
Qboard_line3_left=double(Qboard_line3_left);
Qboard_line5_left=double(Qboard_line5_left);
Qinvehicle_line1_left=double(Qinvehicle_line1_left);
Qinvehicle_line3_left=double(Qinvehicle_line3_left);
Qinvehicle_line5_left=double(Qinvehicle_line5_left);
Qstranded_line1_left=double(Qstranded_line1_left);
Qstranded_line3_left=double(Qstranded_line3_left);
Qstranded_line5_left=double(Qstranded_line5_left);
Qwait_line1_left=double(Qwait_line1_left);
Qwait_line3_left=double(Qwait_line3_left);
Qwait_line5_left=double(Qwait_line5_left);
Cremain_line1_left=double(Cremain_line1_left);
Cremain_line3_left=double(Cremain_line3_left);
Cremain_line5_left=double(Cremain_line5_left);
Departure1=double(Departure1);
Departure3=double(Departure3);
Departure5=double(Departure5);
Arrival1=double(Arrival1);
Arrival3=double(Arrival3);
Arrival5=double(Arrival5);
arf3=double(arf3);
VCor15=double(VCor15);
VCor35=double(VCor35);

% save ����6��������С����ǰ���������112 Qalight_line1_left Qalight_line3_left Qalight_line5_left QArrival_Line1_left QArrival_Line3_left QArrival_Line5_left Qboard_line1_left Qboard_line3_left Qboard_line5_left Qinvehicle_line1_left Qinvehicle_line3_left Qinvehicle_line5_left Qwait_line1_left Qwait_line3_left Qwait_line5_left Cremain_line1_left Cremain_line3_left Cremain_line5_left Departure1 Departure3 Departure5 Arrival1 Arrival3 Arrival5 arf3 VCor15 VCor35 Qstranded_line1_left Qstranded_line3_left Qstranded_line5_left






