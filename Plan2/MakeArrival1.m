function [Z1_Line1,Z1_Line1MIN,Z1_Line1MAX,Z2_Line1,Z2_Line1MIN,Z2_Line1MAX,Z1_Line3,Z1_Line3MIN,Z1_Line3MAX,Z2_Line3,Z2_Line3MIN,Z2_Line3MAX,Z1_Line5,Z1_Line5MIN,Z1_Line5MAX,Z2_Line5,Z2_Line5MIN,Z2_Line5MAX,QArrival_Line1,QArrival_Line1min,QArrival_Line1max,QArrival_Line3,QArrival_Line3min,QArrival_Line3max,QArrival_Line5,QArrival_Line5min,QArrival_Line5max]=MakeArrival(Num1,Num3,Num5,ArrivalRate1,ArrivalRate3,ArrivalRate5,AllDeparture,X3_Line1,X3_Line3,X3_Line5,ETime,STime,Timestamp)
M=10^8;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s3=size(Departure3);
totaltrain3=s3(1,1);
totalstation3=s3(1,2);
s5=size(Departure5);
totaltrain5=s5(1,1);
totalstation5=s5(1,2);
Totalstation=46;

Z1_Line1=intvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z1_Line1MIN=-M*X3_Line1;
Z1_Line1MAX=M*X3_Line1;

Z1_Line3=intvar(totaltrain3*(totalstation3-1),(ETime-STime)/Timestamp);
Z1_Line3MIN=-M*X3_Line3;
Z1_Line3MAX=M*X3_Line3;

Z1_Line5=intvar(totaltrain5*(totalstation5-1),(ETime-STime)/Timestamp);
Z1_Line5MIN=-M*X3_Line5;
Z1_Line5MAX=M*X3_Line5;

Z2_Line1=intvar(totaltrain1*(totalstation1-1),(ETime-STime)/Timestamp);
Z2_Line1MIN=-M*(1-X3_Line1);
Z2_Line1MAX=M*(1-X3_Line1);

Z2_Line3=intvar(totaltrain3*(totalstation3-1),(ETime-STime)/Timestamp);
Z2_Line3MIN=-M*(1-X3_Line3);
Z2_Line3MAX=M*(1-X3_Line3);

Z2_Line5=intvar(totaltrain5*(totalstation5-1),(ETime-STime)/Timestamp);
Z2_Line5MIN=-M*(1-X3_Line5);
Z2_Line5MAX=M*(1-X3_Line5);

QArrival_Line1=intvar(totaltrain1,(totalstation1-1));
QArrival_Line3=intvar(totaltrain3,(totalstation3-1));
QArrival_Line5=intvar(totaltrain5,(totalstation5-1));

QQArrival_Line1=sdpvar(totaltrain1,(totalstation1-1));
QQArrival_Line3=sdpvar(totaltrain3,(totalstation3-1));
QQArrival_Line5=sdpvar(totaltrain5,(totalstation5-1));

cc=0;
for i=1:totaltrain1
    for k=1:8
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            if i==1
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-300;
            else 
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-Departure1(i,k)+Departure(i-1,k);
            end
            if m==1
                QQArrival_Line1(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
            else
                QQArrival_Line1(i,k)=QQArrival_Line1(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
            end
        end
    end
end
for i=1:totaltrain1
    for k=9:15
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num1(i,k);
            if ii==1
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-300;
            else 
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-Departure1(i,k)+AllDeparture((AllDeparture(:,k)==ii-1),k);
            end
            if m==1
                QQArrival_Line1(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
            else
                QQArrival_Line1(i,k)=QQArrival_Line1(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
            end
        end
    end
end
ccc=cc;
for i=1:totaltrain1
    for k=16:23
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num1(i,k);
            if ii==1
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-300;
            else 
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-Departure1(i,k)+Departure3(Num3(Num3(:,k-8)==max(Num3(:,k-8)<ii)),k-8);
            end
            if m==1
                QQArrival_Line1(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
            else
                QQArrival_Line1(i,k)=QQArrival_Line1(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
            end
        end
    end
end
cc=ccc;
for i=1:totaltrain1
    for k=16:23
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num1(i,k);
            if ii==1
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-300;
            else 
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-Departure1(i,k)+AllDeparture((AllDeparture(:,k+17)==ii-1),k+17);
            end
            if m==1
                QQArrival_Line1(i,k)=ArrivalRateGong(k,m)*Z1_Line1(cc,m);
            else
                QQArrival_Line1(i,k)=QQArrival_Line1(i,k)+ArrivalRateGong(k,m)*Z1_Line1(cc,m);
            end
        end
    end
end
for i=1:totaltrain1
    for k=24:28
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num1(i,k);
            if ii==1
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-300;
            else 
                Z2_Line1(cc,m)=Z1_Line1(cc,m)-Departure1(i,k)+AllDeparture((AllDeparture(:,k+17)==ii-1),k+17);
            end
            if m==1
                QQArrival_Line1(i,k)=ArrivalRate1(k,m)*Z1_Line1(cc,m);
            else
                QQArrival_Line1(i,k)=QQArrival_Line1(i,k)+ArrivalRate1(k,m)*Z1_Line1(cc,m);
            end
        end
    end
end
QArrival_Line1min=QQArrival_Line1-0.5;
QArrival_Line1max=QQarrival_Line1+0.5;


cc=0;
for i=1:totaltrain3
    for k=1:7
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num3(i,k);
            if ii==1
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-300;
            else 
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-Departure3(i,k)+AllDeparture((AllDeparture(:,k+8)==ii-1),k+8);
            end
            if m==1
                QQArrival_Line3(i,k)=ArrivalRate3(k,m)*Z1_Line3(cc,m);
            else
                QQArrival_Line3(i,k)=QQArrival_Line3(i,k)+ArrivalRate3(k,m)*Z1_Line3(cc,m);
            end
        end
    end
end
ccc=cc;
for i=1:totaltrain3
    for k=8:15
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num3(i,k);
            if ii==1
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-300;
            else 
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-Departure3(i,k)+Departure1(Num1(Num1(:,k+8)==max(Num1(:,k+8)<ii)),k+8);
            end
            if m==1
                QQArrival_Line3(i,k)=ArrivalRate3(k,m)*Z1_Line3(cc,m);
            else
                QQArrival_Line3(i,k)=QQArrival_Line3(i,k)+ArrivalRate3(k,m)*Z1_Line3(cc,m);
            end
        end
    end
end
cc=ccc;
for i=1:totaltrain3
    for k=8:15
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num3(i,k);
            if ii==1
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-300;
            else 
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-Departure3(i,k)+AllDeparture((AllDeparture(:,k+25)==ii-1),k+25);
            end
            if m==1
                QQArrival_Line3(i,k)=ArrivalRateGong(k,m)*Z1_Line3(cc,m);
            else
                QQArrival_Line3(i,k)=QQArrival_Line3(i,k)+ArrivalRateGong(k,m)*Z1_Line3(cc,m);
            end
        end
    end
end
for i=1:totaltrain3
    for k=16:20
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num3(i,k);
            if ii==1
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-300;
            else 
                Z2_Line3(cc,m)=Z1_Line3(cc,m)-Departure3(i,k)+AllDeparture((AllDeparture(:,k+25)==ii-1),k+25);
            end
            if m==1
                QQArrival_Line3(i,k)=ArrivalRate3(k,m)*Z1_Line3(cc,m);
            else
                QQArrival_Line3(i,k)=QQArrival_Line3(i,k)+ArrivalRate3(k,m)*Z1_Line3(cc,m);
            end
        end
    end
end
QArrival_Line3min=QQArrival_Line3-0.5;
QArrival_Line3max=QQarrival_Line3+0.5;


cc=0;
for i=1:totaltrain5
    for k=1:17
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            if ii==1
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-300;
            else 
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-Departure5(i,k)+Departure5(i-1,k);
            end
            if m==1
                QQArrival_Line5(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m);
            else
                QQArrival_Line5(i,k)=QQArrival_Line5(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m);
            end
        end
    end
end
ccc=cc;
for i=1:totaltrain5
    for k=18:25
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            if ii==1
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-300;
            else 
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-Departure5(i,k)+Departure5(i-1,k);
            end
            if m==1
                QQArrival_Line5(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m);
            else
                QQArrival_Line5(i,k)=QQArrival_Line5(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m);
            end
        end
    end
end
cc=ccc;
for i=1:totaltrain5
    for k=18:25
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            ii=Num5(i,k);
            if ii==1
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-300;
            else 
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-Departure5(i,k)+AllDeparture((AllDeparture(:,k+15)==ii-1),k+15);
            end
            if m==1
                QQArrival_Line5(i,k)=ArrivalRateGong(k,m)*Z1_Line5(cc,m);
            else
                QQArrival_Line5(i,k)=QQArrival_Line5(i,k)+ArrivalRateGong(k,m)*Z1_Line5(cc,m);
            end
        end
    end
end
for i=1:totaltrain5
    for k=26
        cc=cc+1;
        for m=1:(Etime-Stime)/Timestamp
            if ii==1
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-300;
            else 
                Z2_Line5(cc,m)=Z1_Line5(cc,m)-Departure5(i,k)+Departure5(i-1,k);
            end
            if m==1
                QQArrival_Line5(i,k)=ArrivalRate5(k,m)*Z1_Line5(cc,m);
            else
                QQArrival_Line5(i,k)=QQArrival_Line5(i,k)+ArrivalRate5(k,m)*Z1_Line5(cc,m);
            end
        end
    end
end
QArrival_Line5min=QQArrival_Line5-0.5;
QArrival_Line5max=QQarrival_Line5+0.5;

