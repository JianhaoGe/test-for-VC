function [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line5,QArrival11,QArrival51,Waittime11,Waittime51]=MakeOnlyArrival(ArrivalRate1,ArrivalRate5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp)
M=99999;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s5=size(Departure5);
totaltrain5=s5(1,1);
totalstation5=s5(1,2);

Z1_Line1=sdpvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z1_Line1MIN=-M*X3_Line1;
Z1_Line1MAX=M*X3_Line1;

Z1_Line5=sdpvar(totaltrain5*(totalstation5-1),(ETime-STime)/Timestamp);
Z1_Line5MIN=-M*X3_Line5;
Z1_Line5MAX=M*X3_Line5;

Z2_Line1=sdpvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z2_Line1MIN=-M*(1-X3_Line1);
Z2_Line1MAX=M*(1-X3_Line1);

Z2_Line5=sdpvar(totaltrain5*(totalstation5-1),(ETime-STime)/Timestamp);
Z2_Line5MIN=-M*(1-X3_Line5);
Z2_Line5MAX=M*(1-X3_Line5);


QArrival_Line1=sdpvar(totaltrain1,(totalstation1-1));
QArrival_Line5=sdpvar(totaltrain5,(totalstation5-1));
QArrival11=sdpvar(totaltrain1,(totalstation1-1));
Waittime11=sdpvar(totaltrain1,(totalstation1-1));
QArrival51=sdpvar(totaltrain5,(totalstation5-1));
Waittime51=sdpvar(totaltrain5,(totalstation5-1));

%%%根据设定好的开行方案，得到只能乘坐某一列车的乘客的等待时间
for i=1:totaltrain1
    cc=(i-1)*(totalstation1-1);
    for k=1:totalstation1-1
        cc=cc+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                Z1_Line1(cc,m)=Z2_Line1(cc,m)+180;%第一列车取到站前三分钟的客流
            else 
                Z1_Line1(cc,m)=Z2_Line1(cc,m)+Departure1(i,k)-Departure1(i-1,k);
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


%%%在四号线环线上，前车为本线列车
cc=0;
for i=1:totaltrain5
    for k=1:totalstation5-1
        cc=cc+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                Z1_Line5(cc,m)=Z2_Line5(cc,m)+180;
            else 
                Z1_Line5(cc,m)=Z2_Line5(cc,m)+Departure5(i,k)-Departure5(i-1,k);
            end
            if m==1
                QArrival_Line5(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m);
                QArrival51(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m);
                Waittime51(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m)*Z1_Line5(cc,m)/2;
            else
                QArrival_Line5(i,k)=QArrival_Line5(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m);
                QArrival51(i,k)=QArrival51(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m);
                Waittime51(i,k)=Waittime51(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m)*Z1_Line5(cc,m)/2;
            end
        end
    end
end





