clc;close all;clear all;
% %%��ʼ����·������ݣ�Line1Ϊ�����߳���·��Line3Ϊ�����߶̽�·��Line5Ϊ�ĺ��߻���
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
Totaltrain1=72;%��������
Totalstation1=length(Line1.ID)+1;%��վ��
MinR1=fix(Line1.Time)*60+mod(Line1.Time*100,100);%��С��������ʱ��
MaxR1=MinR1*1.2;%�����������ʱ��
Dwelltime1=Dwelltime(Dwelltime.Planning==1,:);%ͣվʱ����ȡ
MinD1=Dwelltime1.Time*100*MinD;%��Сͣվʱ��
MaxD1=MinD1*MaxD;%���ͣվʱ��

%�ĺ��߻���
Line5=Runningtime(Runningtime.Planning==5,:);%��վ��ȡ
Totaltrain5=72;%��������
Totalstation5=length(Line5.ID)+1;%��վ��
MinR5=fix(Line5.Time)*60+mod(Line5.Time*100,100);%��С��������ʱ��
MaxR5=MinR5*1.2;%�����������ʱ��
Dwelltime5=Dwelltime(Dwelltime.Planning==5,:);%ͣվʱ����ȡ
MinD5=Dwelltime5.Time*100*MinD;%��Сͣվʱ��
MaxD5=MinD5*MaxD;%���ͣվʱ��

%%ȷ������վ�����������ߴ�С��·���ĺ��߽�·���֣�
CommonStopSet2=Line1.From(16:24);%���ĺ��߹���վ

% Ss=[Line1.From(1:15);Line5.From(1:17);Line1.From(16:23);Line1.From(24:28);Line5.From(26)];%���յ�վ��ĳ�վ

%���ɱ�������ʱ�̼�����ʱ��
Arrival1=intvar(Totaltrain1,Totalstation1);
Departure1=intvar(Totaltrain1,Totalstation1);
Arrival5=intvar(Totaltrain5,Totalstation5);
Departure5=intvar(Totaltrain5,Totalstation5);

%%������������Լ����ͣվԼ��
[Runtime1MAX,ConRuntime1,Runtime1MIN]=MakeRuntimeContraints(Arrival1,Departure1,MinR1,MaxR1);
[Dwelltime1MAX,ConDwelltime1,Dwelltime1MIN]=MakeDwelltimeContraints(Arrival1,Departure1,MinD1,MaxD1);
[Runtime5MAX,ConRuntime5,Runtime5MIN]=MakeRuntimeContraints(Arrival5,Departure5,MinR5,MaxR5);
[Dwelltime5MAX,ConDwelltime5,Dwelltime5MIN]=MakeDwelltimeContraints(Arrival5,Departure5,MinD5,MaxD5);

%%���ɳ�ͷʱ��Լ������Ϊͬ��·�䳵ͷʱ�ࡢͬ�߲�ͬ��·��ͷʱ���벻ͬ�߳�ͷʱ�ࣩ
%%ͬ��·�䳵ͷʱ��Լ��
[Headway1MAX,ConHeadway1,Headway1MIN]=MakeSameHeadwayConstraints(Line1,Arrival1,Departure1,MinH,MaxH);
[Headway5MAX,ConHeadway5,Headway5MIN]=MakeSameHeadwayConstraints(Line5,Arrival5,Departure5,MinH,MaxH);
%%��ͬ�߳�ͷʱ��Լ�����������������߱�����
[Headway15MAX,ConHeadway15,Headway15MIN,VCor15]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line5,Arrival5,Departure5,MinH,MaxH,CommonStopSet2);
%%�����ĺ������ܾ���
% [arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink5,AllRunningtime5]=MakeLink(Arrival5);
%%�����ĺ�������Լ��
% [L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival5);
%%�������������߱��������ڿ���Լ����
VCnot15=binvar(Totaltrain1,2);

disp("ʱ�̱�ģ���");
%%ʱ�̱�Լ��
CTimetable=[Arrival1(1,1)==6*3600;
    Arrival1>=6*3600;
    Departure1>=6*3600;
    Arrival5>=6*3600;
    Departure5>=6*3600;
    Departure5<=11*3600;
    Departure1<=11*3600;
    Departure5(:,18:26)>Departure1(:,16:24);
    Runtime1MIN<=ConRuntime1;
    ConRuntime1<=Runtime1MAX;
    Dwelltime1MIN<=ConDwelltime1;
    ConDwelltime1<=Dwelltime1MAX;
    Runtime5MIN<=ConRuntime5;
    ConRuntime5<=Runtime5MAX;
    Dwelltime5MIN<=ConDwelltime5;
    ConDwelltime5<=Dwelltime5MAX;
    Headway1MIN<=ConHeadway1;
    ConHeadway1<=Headway1MAX;
    Headway5MIN<=ConHeadway5;
    ConHeadway5<=Headway5MAX;
    Headway15MIN.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15]<=ConHeadway15;
    ConHeadway15<=Headway15MAX.*[VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15,VCor15]+MinVC.*[VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15,VCnot15];
%     VCor15(:,1)+VCor15(:,2)>=ones(Totaltrain1,1);
    VCor15(:,1)==0;
    VCor15(:,2)==1;
    VCor15+VCnot15==ones(Totaltrain1,2);
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
%     sum(arf3(7,:))==1;
%     sum(arf3(8,:))==1;
%     sum(arf3(9,:))==1;
%     sum(arf3(10,:))==1;%ǿ��Ҫ��ǰʮ���ĺ�������
    ];
disp("ʱ�̱�Լ�����");
% %����Լ������
% %������Ϣ����
% STime=7*3600;
% ETime=11*3600;
% Timestamp=300;
% load('PassengerDown2.mat');
% % load('PassengerDown3.mat');
% load('PassengerDown4.mat');
% 
% bs=1;
% %����ʵ���ݳ���1.5��Ϊʵ������
% ArrivalRate1=ArrivalRate1*bs;
% ArrivalRate3=ArrivalRate3*bs;
% ArrivalRate5=ArrivalRate5*bs;
% ArrivalRateShare=ArrivalRateShare*bs;
% AlightRate1=AlightRate1*bs;
% AlightRate3=AlightRate3*bs;
% AlightRate5=AlightRate5*bs;
% AlightRateShare=AlightRateShare*bs;
%����������ʱ�̱����ڿ������ݵĲ��Բ���
% Arrival1=double(Arrival1);
% Arrival3=double(Arrival3);
% Arrival5=double(Arrival5);
% Departure1=double(Departure1);
% Departure3=double(Departure3);
% Departure5=double(Departure5);
% arf3=double(arf3);

% %%%��ʼ����������
% Cremain_line1_left=sdpvar(Totaltrain1,Totalstation1);
% Qboard_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
% Qinvehicle_line1_left=sdpvar(Totaltrain1,Totalstation1);
% Qstranded_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
% Qwait_line1_left=sdpvar(Totaltrain1,Totalstation1-1);
% QArrival_Line1_left=sdpvar(Totaltrain1,Totalstation1-1);
% Qalight_line1_left=sdpvar(Totaltrain1,Totalstation1);
% 
% Cremain_line5_left=sdpvar(Totaltrain5,Totalstation5);
% Qboard_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
% Qinvehicle_line5_left=sdpvar(Totaltrain5,Totalstation5);
% Qstranded_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
% Qwait_line5_left=sdpvar(Totaltrain5,Totalstation5-1);
% QArrival_Line5_left=sdpvar(Totaltrain5,Totalstation5-1);
% Qalight_line5_left=sdpvar(Totaltrain5,Totalstation5);
% 
% disp("�����������");
% %%%ʱ�����ģ
% 
% % [X1_Line1,X1left_Line1,X1right_Line1,X2_Line1,X2left_Line1,X2right_Line1,X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval(Departure1,STime,ETime,Timestamp);
% % [X1_Line3,X1left_Line3,X1right_Line3,X2_Line3,X2left_Line3,X2right_Line3,X3_Line3,X3left_Line3,X3right_Line3] = GetTimeInterval(Departure3,STime,ETime,Timestamp);
% % [X1_Line5,X1left_Line5,X1right_Line5,X2_Line5,X2left_Line5,X2right_Line5,X3_Line5,X3left_Line5,X3right_Line5] = GetTimeInterval(Departure5,STime,ETime,Timestamp);
% 
% [X3_Line1,X3left_Line1,X3right_Line1] = GetTimeInterval2(Departure1,STime,ETime,Timestamp);
% [X3_Line5,X3left_Line5,X3right_Line5] = GetTimeInterval2(Departure5,STime,ETime,Timestamp);
% 
% disp("ʱ�����ģ���");
% 
% % [aamin,aamax,aa,Num1,Num3,Num5,Numall,AllDeparture]=MakeNum(Departure1,Departure3,Departure5,Line1,Line3,Line5,Ss);
% % 
% % [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line3,Z1_Line3MIN,Z1_Line3MAX,Z2_Line3,Z2_Line3MIN,Z2_Line3MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line1min,QArrival_Line1max,QArrival_Line3,QArrival_Line3min,QArrival_Line3max,QArrival_Line5,QArrival_Line5min,QArrival_Line5max]=MakeArrival(Num1,Num3,Num5,ArrivalRate1,ArrivalRate3,ArrivalRate5,AllDeparture,X3_Line1,X3_Line3,X3_Line5,ETime,STime,Timestamp);
% 
% %%%�����˿͵����Ϊֻ�ܳ���������/�ĺ��� �� ���߾��ɳ��� ���ֿ�����
% [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line5,QArrival11,QArrival51,Waittime11,Waittime51]=MakeOnlyArrival(ArrivalRate1,ArrivalRate5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp);
% [Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line5,Z3_Line5MIN,Z3_Line5MAX,Z4_Line5,Z4_Line5MIN,Z4_Line5MAX,Z5_Line5,Z5_Line5MIN,Z5_Line5MAX,Z6_Line5,Z6_Line5MIN,Z6_Line5MAX,Z7_Line5,Z7_Line5MIN,Z7_Line5MAX,Z8_Line5,Z8_Line5MIN,Z8_Line5MAX,QArrival_Line1,QArrival_Line5,QArrival12,QArrival52,Waittime12,Waittime52]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp,VCor15);
% disp("�������ｨģ���");
% %%%�г�������ģ
% Cremain_line1_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line1_left);
% Cremain_line5_right = MakeRemainCapacityinVehicle(Cmax,Qinvehicle_line5_left);
% disp("�г�������ģ���");
% %%%�˿��ϳ���ģ
% Qboard_line1_right = MakeBoard(Qwait_line1_left,Cremain_line1_left);
% Qboard_line5_right = MakeBoard(Qwait_line5_left,Cremain_line5_left);
% disp("�˿��ϳ���ģ���");
% %%%�˿��ڳ���վ�ڣ���ģ��Qinvehicle��ʾ��ͣ��ĳһվ�¿������δ�Ͽ�ʱ�ĳ��ڳ˿�������
% Qinvehicle_line1_right = Makeinvehicle(Qboard_line1_left,Qalight_line1_left);
% % Qinvehicle_line5_right = Makeinvehicle(Qboard_line5_left,Qalight_line5_left);
% [Qinvehicle_line5_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicle5(Qboard_line5_left,Qalight_line5_left,arf3);
% disp("�˿��ڳ���վ�ڣ���ģ���");
% %%%�˿�������ģ
% Qstranded_line1_right = Makestranded(Qwait_line1_left,Qboard_line1_left);
% Qstranded_line5_right = Makestranded(Qwait_line5_left,Qboard_line5_left);
% disp("�˿�������ģ���");
% %%%�˿͵ȴ���ģ
% Qwait_line1_right = Makewait(QArrival_Line1_left,Qstranded_line1_left);
% Qwait_line5_right = Makewait(QArrival_Line5_left,Qstranded_line5_left);
% disp("�˿͵ȴ���ģ���");
% %%%�˿��³���ģ
% [Qalight_Line1_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure5,Qboard_line5_left,Rate5,arf3);
% disp("�˿��³���ģ���");
% 
% %����Լ��
% CTimestamp=[sum(X3_Line1,2)==ones(Totaltrain1*(Totalstation1-1),1);
%     sum(X3_Line5,2)==ones(Totaltrain5*(Totalstation5-1),1);
%     X3left_Line1+0.01<=Departure1(:,1:end-1)-STime;
%     Departure1(:,1:end-1)-STime<=X3right_Line1;
%     X3left_Line5+0.01<=Departure5(:,1:end-1)-STime;
%     Departure5(:,1:end-1)-STime<=X3right_Line5;];
% CArrival=[Z1_Line1MIN<=Z1_Line1;
%     Z1_Line1<=Z1_Line1MAX;
%     Z1_Line5MIN<=Z1_Line5;
%     Z1_Line5<=Z1_Line5MAX;
%     Z2_Line1MIN<=Z2_Line1;
%     Z2_Line1<=Z2_Line1MAX;
%     Z2_Line5MIN<=Z2_Line5;
%     Z2_Line5<=Z2_Line5MAX;
%     Z3_Line1MIN<=Z3_Line1;
%     Z3_Line1<=Z3_Line1MAX;
%     Z3_Line5MIN<=Z3_Line5;
%     Z3_Line5<=Z3_Line5MAX;
%     Z4_Line1MIN<=Z4_Line1;
%     Z4_Line1<=Z4_Line1MAX;
%     Z4_Line5MIN<=Z4_Line5;
%     Z4_Line5<=Z4_Line5MAX;
%     Z5_Line1MIN<=Z5_Line1;
%     Z5_Line1<=Z5_Line1MAX;
%     Z5_Line5MIN<=Z5_Line5;
%     Z5_Line5<=Z5_Line5MAX;
%     Z6_Line1MIN<=Z6_Line1;
%     Z6_Line1<=Z6_Line1MAX;
%     Z6_Line5MIN<=Z6_Line5;
%     Z6_Line5<=Z6_Line5MAX;
%     Z7_Line1MIN<=Z7_Line1;
%     Z7_Line5MIN<=Z7_Line5;
%     Z7_Line5<=Z7_Line5MAX;
%     Z8_Line1MIN<=Z8_Line1;
%     Z8_Line1<=Z8_Line1MAX;
%     Z8_Line5MIN<=Z8_Line5;
%     Z8_Line5<=Z8_Line5MAX;
%     QArrival_Line1_left==QArrival_Line1;
%     QArrival_Line5_left==QArrival_Line5;];
% Calight=[Qalight_line1_left==Qalight_Line1_right;
%     Qalight_line5_left==Qalight_Line5_right;
%     ZZ3min<=ZZ3;
%     ZZ3<=ZZ3max;
%     ZZ4min<=ZZ4
%     ZZ4<=ZZ4max;];
% CCremain=[Cremain_line1_left==Cremain_line1_right;
%     Cremain_line5_left==Cremain_line5_right;];
% Cboard=[
%     Qboard_line1_left<=Qwait_line1_left;
%     Qboard_line5_left<=Qwait_line5_left;
%     Qboard_line1_left<=Cremain_line1_left(:,1:Totalstation1-1);
%     Qboard_line5_left<=Cremain_line5_left(:,1:Totalstation5-1);
%     Qboard_line1_left>=0;
%     Qboard_line5_left>=0;
%     ];
% Cinvehicle=[Qinvehicle_line1_left==Qinvehicle_line1_right;
%     Qinvehicle_line5_left==Qinvehicle_line5_right;
%     ZZ1min<=ZZ1;
%     ZZ1<=ZZ1max;
%     ZZ2min<=ZZ2;
%     ZZ2<=ZZ2max;];
% Cstranded=[Qstranded_line1_left==Qstranded_line1_right;
%     Qstranded_line5_left==Qstranded_line5_right;];
% Cwait=[Qwait_line1_left==Qwait_line1_right;
%     Qwait_line5_left==Qwait_line5_right;];
% disp("����Լ�����");
C=[
    CTimetable;
%     CTimestamp;
%     CArrival;
%     Calight;
%     CCremain;
%     Cboard;
%     Cinvehicle;
%     Cstranded;
%     Cwait;
    ];

% obj=sum(sum(Qstranded_line1_left))+sum(sum(Qstranded_line5_left));
% obj=sum(sum(ConRuntime1))+sum(sum(ConRuntime5));
obj=sum(sum(Departure1))+sum(sum(Departure5));
ops = sdpsettings('solver','gurobi');
result=solvesdp(C,obj,ops);

% Display2;
% % %����������
% % d1=double(Departure1);
% % d5=double(Departure5);
% % a1=double(Arrival1);
% % a5=double(Arrival5);
% % 
% % 
% % for i=1:Totaltrain1
% %     a=29;
% %     for j=1:28
% %         x=[];
% %         y=[];
% %         x(1)=double(Arrival1(i,j));
% %         y(1)=a;
% %         x(2)=double(Departure1(i,j));
% %         y(2)=a;
% %         plot(x,y,'k');
% %         hold on
% %         x=[];
% %         y=[];
% %         x(1)=double(Departure1(i,j));
% %         y(1)=a;
% %         x(2)=double(Arrival1(i,j+1));
% %         y(2)=a-1;
% %         plot(x,y,'k');
% %         hold on
% %         a=a-1;
% %     end
% % end
% % 
% % for i=1:Totaltrain5
% %     c=47;
% %     for j=1:17
% %         x=[];
% %         y=[];
% %         x(1)=double(Arrival5(i,j));
% %         y(1)=c;
% %         x(2)=double(Departure5(i,j));
% %         y(2)=c;
% %         plot(x,y,'r');
% %         hold on
% %         x=[];
% %         y=[];
% %         x(1)=double(Departure5(i,j));
% %         y(1)=c;
% %         x(2)=double(Arrival5(i,j+1));
% %         y(2)=c-1;
% %         plot(x,y,'r');
% %         hold on
% %         c=c-1;
% %     end
% %     c=14;
% %     for j=18:25
% %         x=[];
% %         y=[];
% %         x(1)=double(Arrival5(i,j));
% %         y(1)=c;
% %         x(2)=double(Departure5(i,j));
% %         y(2)=c;
% %         plot(x,y,'r');
% %         hold on
% %         x=[];
% %         y=[];
% %         x(1)=double(Departure5(i,j));
% %         y(1)=c;
% %         x(2)=double(Arrival5(i,j+1));
% %         y(2)=c-1;
% %         plot(x,y,'r');
% %         hold on
% %         c=c-1;
% %     end
% %         x=[];
% %         y=[];
% %         x(1)=double(Arrival5(i,j+1));
% %         y(1)=1;
% %         x(2)=double(Departure5(i,j+1));
% %         y(2)=1;
% %         plot(x,y,'r');
% %         hold on
% %         x=[];
% %         y=[];
% %         x(1)=double(Departure5(i,j+1));
% %         y(1)=1;
% %         x(2)=double(Arrival5(i,j+2));
% %         y(2)=0;
% %         plot(x,y,'r');
% %         hold on
% % end
% 
% 
% Qalight_line1_left=double(Qalight_line1_left);
% Qalight_line5_left=double(Qalight_line5_left);
% QArrival_Line1_left=double(QArrival_Line1_left);
% QArrival_Line5_left=double(QArrival_Line5_left);
% Qboard_line1_left=double(Qboard_line1_left);
% Qboard_line5_left=double(Qboard_line5_left);
% Qinvehicle_line1_left=double(Qinvehicle_line1_left);
% Qinvehicle_line5_left=double(Qinvehicle_line5_left);
% Qstranded_line1_left=double(Qstranded_line1_left);
% Qstranded_line5_left=double(Qstranded_line5_left);
% Qwait_line1_left=double(Qwait_line1_left);
% Qwait_line5_left=double(Qwait_line5_left);
% Cremain_line1_left=double(Cremain_line1_left);
% Cremain_line5_left=double(Cremain_line5_left);
% Departure1=double(Departure1);
% Departure5=double(Departure5);
% Arrival1=double(Arrival1);
% Arrival5=double(Arrival5);
% arf3=double(arf3);
% VCor15=double(VCor15);

% save ����6��������С����ǰ����������11 Qalight_line1_left Qalight_line5_left QArrival_Line1_left QArrival_Line5_left Qboard_line1_left Qboard_line5_left Qinvehicle_line1_left Qinvehicle_line5_left Qwait_line1_left Qwait_line5_left Cremain_line1_left Cremain_line5_left Departure1 Departure5 Arrival1 Arrival5 arf3 VCor15 Qstranded_line1_left Qstranded_line5_left




