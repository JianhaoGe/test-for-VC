function [Headway12MAX,ConHeadway12,Headway12MIN,VCor12,VCnot12]=MakeDifferentLineHeadwayConstraints(Line1,Arrival1,Departure1,Line2,Arrival2,Departure2,MinH,MaxH,CommonStopSet2)
s=size(Arrival1);
num_train=s(1,1);
ConHeadway12=sdpvar(num_train,length(CommonStopSet2)*2);

%% VCor12 is the decision variable showing the virtual coupling relationship between trains of Line 1 and Line 2.
%% The first row represents whether it is coupled with the front train and the second row represents whether it is coupled with the rear train.
VCor12=binvar(num_train,2);
VCnot12=binvar(num_train,2);
Headway12MIN=MinH*ones(num_train,length(CommonStopSet2)*2);
Headway12MAX=MaxH*ones(num_train,length(CommonStopSet2)*2);
count=0;
for i=1:length(CommonStopSet2)
     line1=Line1(Line1==CommonStopSet2(i),:);
     line2=Line2(Line2==CommonStopSet2(i),:);
     id1=find(Line1==line1);
     id2=find(Line2==line2);
     count=count+1;
     ConHeadway12(:,count)=Arrival2(:,id2)-Arrival1(:,id1);
     count=count+1;
     ConHeadway12(2:num_train,count)=Arrival1(2:num_train,id1)-Arrival2(1:end-1,id2);
     %% ConHeadway12 is used to show the headway between the two successive trains of different lines at stations in the collinear corridor.
     %% For trains of Line 1, the odd row of ConHeadway12 represents the headway with its front train and the even row represents the headway with its rear train.  
end
