function [Headway15MAX,ConHeadway15,Headway15MIN,VCor15]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line5,Arrival5,Departure5,MinH,MaxH,CommonStopSet2)
s=size(Arrival5);
num_train=s(1,1);
ConHeadway15=sdpvar(num_train,length(CommonStopSet2)*2);
%虚拟编组决策变量，前列代表是否与前车编组，后列代表是否与后车编组，均以三号线列车为对象
VCor15=binvar(num_train,2);
Headway15MIN=(MinH+40)*ones(num_train,length(CommonStopSet2)*2);
Headway15MAX=(MaxH+40)*ones(num_train,length(CommonStopSet2)*2);
count=0;
for i=1:length(CommonStopSet2)
     line1=Line1(Line1.From==CommonStopSet2(i),:);
     line5=Line5(Line5.From==CommonStopSet2(i),:);
     id1=line1.ID;
     id5=line5.ID;
     count=count+1;
     ConHeadway15(:,count)=Arrival5(:,id5)-Arrival1(2:2:2*num_train,id1);
     count=count+1;
     ConHeadway15(1:num_train-1,count)=Arrival1(3:2:2*num_train-1,id1)-Arrival5(1:num_train-1,id5);
end
