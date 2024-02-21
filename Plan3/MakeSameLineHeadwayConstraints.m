function [Headway13MAX,ConHeadway13,Headway13MIN]=MakeSameLineHeadwayConstraints(Line1,Arrival1,Departure1,Line3,Arrival3,Departure3,MinH,MaxH,CommonStopSet1)
s=size(Arrival1);
num_train=s(1,1);
ConHeadway13=sdpvar(num_train,length(CommonStopSet1)*2);
count=0;
for i=1:length(CommonStopSet1)
     line1=Line1(Line1.From==CommonStopSet1(i),:);
     line3=Line3(Line3.From==CommonStopSet1(i),:);
     id1=line1.ID;
     id3=line3.ID;
     count=count+1;
     ConHeadway13(:,count)=Arrival3(:,id3)-Departure1(:,id1);
     count=count+1;
     ConHeadway13(1:num_train-1,count)=Arrival1(2:num_train,id1)-Departure3(1:num_train-1,id3);
end

Headway13MIN=MinH*ones(num_train,length(CommonStopSet1)*2);
Headway13MAX=MaxH*ones(num_train,length(CommonStopSet1)*2);