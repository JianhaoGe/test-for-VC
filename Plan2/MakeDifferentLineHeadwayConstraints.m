function [Headway15MAX,ConHeadway15,Headway15MIN,VCor15,Headway35MAX,ConHeadway35,Headway35MIN,VCor35]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line3,Arrival3,Departure3,Line5,Arrival5,Departure5,MinH,MaxH,CommonStopSet2)
s=size(Arrival1);
num_train=s(1,1);
ConHeadway15=sdpvar(num_train,length(CommonStopSet2)*2);
ConHeadway35=sdpvar(num_train,length(CommonStopSet2)*2);
%虚拟编组决策变量，前列代表是否与前车编组，后列代表是否与后车编组，均以三号线列车为对象
VCor15=binvar(num_train,2);
VCor35=binvar(num_train,2);
% Headway15MIN=sdpvar(num_train,length(CommonStopSet2)*2);
% Headway15MAX=sdpvar(num_train,length(CommonStopSet2)*2);
% Headway35MIN=sdpvar(num_train,length(CommonStopSet2)*2);
% Headway35MAX=sdpvar(num_train,length(CommonStopSet2)*2);
Headway15MIN=(MinH+40)*ones(num_train,length(CommonStopSet2)*2);
Headway15MAX=(MaxH+40)*ones(num_train,length(CommonStopSet2)*2);
Headway35MIN=(MinH+40)*ones(num_train,length(CommonStopSet2)*2);
Headway35MAX=(MaxH+40)*ones(num_train,length(CommonStopSet2)*2);
count=0;
for i=1:length(CommonStopSet2)
     line1=Line1(Line1.From==CommonStopSet2(i),:);
     line3=Line3(Line3.From==CommonStopSet2(i),:);
     line5=Line5(Line5.From==CommonStopSet2(i),:);
     id1=line1.ID;
     id3=line3.ID;
     id5=line5.ID;
     count=count+1;
     ConHeadway15(:,count)=Arrival5(1:2:end,id5)-Arrival1(:,id1);
%      Headway15MIN(:,count)=MinH*ones(num_train,1)+Departure1(:,id1)-Arrival1(:,id1);
%      Headway15MAX(:,count)=MaxH*ones(num_train,1)+Headway15MAX(:,count)+Departure1(:,id1)-Arrival1(:,id1);
     ConHeadway35(:,count)=Arrival5(2:2:end,id5)-Arrival3(:,id3);
%      Headway35MIN(:,count)=MinH*ones(num_train,1)+Departure3(:,id3)-Arrival3(:,id3);
%      Headway35MAX(:,count)=MaxH*ones(num_train,1)+Departure3(:,id3)-Arrival3(:,id3);
     count=count+1;
     ConHeadway15(2:num_train,count)=Arrival1(2:num_train,id1)-Arrival5(2:2:end-2,id5);
%      Headway15MIN(1:num_train-1,count)=MinH*ones(num_train-1,1)+Departure5(2:2:end-2,id5)-Arrival5(2:2:end-2,id5);
%      Headway15MAX(1:num_train-1,count)=MaxH*ones(num_train-1,1)+Departure5(2:2:end-2,id5)-Arrival5(2:2:end-2,id5);
     ConHeadway35(:,count)=Arrival3(:,id3)-Arrival5(1:2:end,id5);
%      Headway35MIN(:,count)=MinH*ones(num_train,1)+Departure5(1:2:end,id5)-Arrival5(1:2:end,id5);
%      Headway35MAX(:,count)=MaxH*ones(num_train,1)+Departure5(1:2:end,id5)-Arrival5(1:2:end,id5);
end
