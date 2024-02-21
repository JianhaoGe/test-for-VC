function [X3,X3left,X3right] = GetTimeInterval2(Departure,Stime,Etime,Timestamp)

s=size(Departure);
totaltrain=s(1,1);
totalstation=s(1,2);



%% 

X3=binvar(totaltrain*(totalstation-1),(Etime-Stime)/Timestamp);
X3left=sdpvar(totaltrain,totalstation-1);
X3right=sdpvar(totaltrain,totalstation-1);

cc=0;
for i=1:totaltrain
    for k=1:totalstation-1
        cc=cc+1;
        ccc=1;
        for m=1:(Etime-Stime)/Timestamp
            if ccc==1
                X3left(i,k)=X3(cc,m)*(m-1)*Timestamp;
                X3right(i,k)=X3(cc,m)*m*Timestamp;
            else
                X3left(i,k)=X3left(i,k)+X3(cc,m)*(m-1)*Timestamp;
                X3right(i,k)=X3right(i,k)+X3(cc,m)*m*Timestamp;
            end
            ccc=ccc+1;
        end
    end
end