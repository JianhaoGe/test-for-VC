function [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line2,Z1_Line2MIN,Z1_Line2MAX,Z2_Line2,Z2_Line2MIN,Z2_Line2MAX,QArrival_Line1,QArrival_Line2,QArrival11,QArrival21,Waittime11,Waittime21]=MakeOnlyArrival(ArrivalRate1,ArrivalRate2,X3_Line1,X3_Line2,Departure1,Departure2,ETime,STime,Timestamp)
%% Due to linearization in Constraints (33-34,37-38), PCM method is extensively used here.

M=99999;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s2=size(Departure2);
totaltrain2=s2(1,1);
totalstation2=s2(1,2);

%% Z1_Line1 is used to show the headway between the train and its front train of Line 1 if the train arrives at the station within the specific time period.
%% Z1_Line2 is used to show the headway between the train and its front train of Line 2 if the train arrives at the station within the specific time period.
%% Z2_Line1 and Z2_Line2 are auxiliary variables. 


Z1_Line1=sdpvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z1_Line1MIN=-M*X3_Line1;
Z1_Line1MAX=M*X3_Line1;

Z1_Line2=sdpvar(totaltrain2*(totalstation2-1),(ETime-STime)/Timestamp);
Z1_Line2MIN=-M*X3_Line2;
Z1_Line2MAX=M*X3_Line2;

Z2_Line1=sdpvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z2_Line1MIN=-M*(1-X3_Line1);
Z2_Line1MAX=M*(1-X3_Line1);

Z2_Line2=sdpvar(totaltrain2*(totalstation2-1),(ETime-STime)/Timestamp);
Z2_Line2MIN=-M*(1-X3_Line2);
Z2_Line2MAX=M*(1-X3_Line2);

%% The following variables are used to analyze the passenger service quality, which are not constrained in the model.
QArrival_Line1=sdpvar(totaltrain1,(totalstation1-1));
QArrival_Line2=sdpvar(totaltrain2,(totalstation2-1));
QArrival11=sdpvar(totaltrain1,(totalstation1-1));
Waittime11=sdpvar(totaltrain1,(totalstation1-1));
QArrival21=sdpvar(totaltrain2,(totalstation2-1));
Waittime21=sdpvar(totaltrain2,(totalstation2-1));

%%%According to the plan, obtain the number of arriving passengers who can only take a certain train
for i=1:totaltrain1
    cc=(i-1)*(totalstation1-1);
    for k=1:totalstation1-1
        cc=cc+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                %% The number of arriving passengers of the first train obtains the passenger flow three minutes before the first train arrives at the station
                %% Z1_Line1(cc,m)=180.
            else 
                %% Z1_Line1(cc,m)=Departure1(i,k)-Departure1(i-1,k).
                %% Note: the code is not correct.
            end
            if m==1
                QArrival_Line1(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
                QArrival11(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
                Waittime11(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m)*Z1_Line1(cc,m)/2;
            else
                QArrival_Line1(i,k)=QArrival_Line1(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
                QArrival11(i,k)=QArrival11(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
                Waittime11(i,k)=Waittime11(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m)*Z1_Line1(cc,m)/2;
            end
        end
    end
end


cc=0;
for i=1:totaltrain2
    for k=1:totalstation2-1
        cc=cc+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                %% Z1_Line2(cc,m)=180.
            else 
                %% Z1_Line2(cc,m)=Departure2(i,k)-Departure2(i-1,k);
                %% Note: the code is not correct.
            end
            if m==1
                QArrival_Line2(i,k)=ArrivalRate2(k,m)*Z1_Line2(cc,m);
                QArrival21(i,k)=ArrivalRate2(k,m)*Z1_Line2(cc,m);
                Waittime21(i,k)=ArrivalRate2(k,m)*Z1_Line2(cc,m)*Z1_Line2(cc,m)/2;
            else
                QArrival_Line2(i,k)=QArrival_Line2(i,k)+ArrivalRate2(k,m)*Z1_Line2(cc,m);
                QArrival21(i,k)=QArrival21(i,k)+ArrivalRate2(k,m)*Z1_Line2(cc,m);
                Waittime21(i,k)=Waittime21(i,k)+ArrivalRate2(k,m)*Z1_Line2(cc,m)*Z1_Line2(cc,m)/2;
            end
        end
    end
end





