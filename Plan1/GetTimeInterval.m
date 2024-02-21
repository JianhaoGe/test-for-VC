function [X1,X1left,X1right,X2,X2left,X2right,X3,X3left,X3right] = GetTimeInterval(Departure,Stime,Etime,Timestamp)

M=99999;

s=size(Departure);
totaltrain=s(1,1);
totalstation=s(1,2);



%% 

X1=binvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X1left=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X1right=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);

X2=binvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X2left=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X2right=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);

X3=binvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X3left=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X3right=sdpvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);


cc=0;
for i=1:totaltrain
    for k=1:totalstation-1
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            t=(m-1)*Timestamp+Stime;
            X1left(cc,m)=(Departure(i,k)-t)/M;
            X1right(cc,m)=1+(Departure(i,k)-t)/M;
            
            X2left(cc,m)=(t+Timestamp-Departure(i,k))/M;
            X2right(cc,m)=1+(t+Timestamp-Departure(i,k))/M;
            
            X3left(cc,m)=(X1(cc,m)+X2(cc,m)-1.5)/M;
            X3right(cc,m)=1+(X1(cc,m)+X2(cc,m)-1.5)/M;
        end
    end
end

