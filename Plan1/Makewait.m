function Qwait_right = Makewait(QArrival_left,Qstranded_left)
s=size(QArrival_left);
totaltrain=s(1,1);
%% Constraints (18-19)
Qwait_right(1,:)=QArrival_left(1,:);
Qwait_right(2:totaltrain,:)=QArrival_left(2:end,:)+Qstranded_left(1:end-1,:);
