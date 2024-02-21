function [HeadwayMAX,ConHeadway,HeadwayMIN]=MakeSameHeadwayConstraints(Line,Arrival,Departure,MinH,MaxH)
s=size(Arrival);
num_train=s(1,1);
ConHeadway=sdpvar(num_train-1,length(Line.From));
for i=1:length(Line.From)
    ConHeadway(:,i)=Arrival(2:num_train,i)-Departure(1:num_train-1,i);
end
HeadwayMAX=MaxH*ones(num_train-1,i);
HeadwayMIN=MinH*ones(num_train-1,i);