function [Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line5,Z3_Line5MIN,Z3_Line5MAX,Z4_Line5,Z4_Line5MIN,Z4_Line5MAX,Z5_Line5,Z5_Line5MIN,Z5_Line5MAX,Z6_Line5,Z6_Line5MIN,Z6_Line5MAX,Z7_Line5,Z7_Line5MIN,Z7_Line5MAX,Z8_Line5,Z8_Line5MIN,Z8_Line5MAX,QArrival_Line1,QArrival_Line5,QArrival12,QArrival52,Waittime12,Waittime52]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line5,X3_Line1,X3_Line5,Departure1,Departure5,ETime,STime,Timestamp,VCor15)
M=10^8;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s5=size(Departure5);
totaltrain5=s5(1,1);
totalstation5=s5(1,2);
CommonStop=8;
%%%生成三四号线共线段的间隔参数
Z3_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
za1=[];
for i=1:totaltrain1
    za1=[za1,(i-1)*(totalstation1-1)+16:(i-1)*(totalstation1-1)+23];
end
Z3_Line1MIN=-M*X3_Line1(za1,:);
Z3_Line1MAX=M*X3_Line1(za1,:);

Z3_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
za5=[];
for i=1:totaltrain5
    za5=[za5,(i-1)*(totalstation5-1)+18:(i-1)*(totalstation5-1)+25];
end
Z3_Line5MIN=-M*X3_Line5(za5,:);
Z3_Line5MAX=M*X3_Line5(za5,:);

Z4_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line1MIN=-M*(1-X3_Line1(za1,:));
Z4_Line1MAX=M*(1-X3_Line1(za1,:));

Z4_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line5MIN=-M*(1-X3_Line5(za5,:));
Z4_Line5MAX=M*(1-X3_Line5(za5,:));

%%%生成三四号线共线段是否虚拟编组的相关参数，四号线被分割为了前车为三号线长交路与前车为三号线短交路两种情况
%%%此处为模型的线性化
%%%若与前车进行虚拟编组，则到达乘客数加上Z5

cc=0;
for i=1:totaltrain5
    for j=1:CommonStop
        cc=cc+1;
        VC_Line1(cc,1)=VCor15(i,2);
    end
end
Z5_Line1=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line1MIN=-M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));
Z5_Line1MAX=M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));

cc=0;
for i=1:totaltrain5
    for j=1:CommonStop
        cc=cc+1;
        VC_Line5(cc,1)=VCor15(i,1);
    end
end
Z5_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line5MIN=-M*(1-repmat(VC_Line5,1,(ETime-STime)/Timestamp));
Z5_Line5MAX=M*(1-repmat(VC_Line5,1,(ETime-STime)/Timestamp));

Z6_Line1=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line1MIN=-M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);
Z6_Line1MAX=M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);

Z6_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line5MIN=-M*repmat(VC_Line5,1,(ETime-STime)/Timestamp);
Z6_Line5MAX=M*repmat(VC_Line5,1,(ETime-STime)/Timestamp);

%%%若与后车进行虚拟编组则到达乘客数加上Z7
Z7_Line1=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line1MIN=-M*(1-repmat(VC_Line5,1,(ETime-STime)/Timestamp));
Z7_Line1MAX=M*(1-repmat(VC_Line5,1,(ETime-STime)/Timestamp));

Z7_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line5MIN=-M*(1-repmat([VC_Line1(1:end-1,1);0],1,(ETime-STime)/Timestamp));
Z7_Line5MAX=M*(1-repmat([VC_Line1(1:end-1,1);0],1,(ETime-STime)/Timestamp));

Z8_Line1=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line1MIN=-M*repmat(VC_Line5,1,(ETime-STime)/Timestamp);
Z8_Line1MAX=M*repmat(VC_Line5,1,(ETime-STime)/Timestamp);

Z8_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line5MIN=-M*repmat([VC_Line1(1:end-1,1);0],1,(ETime-STime)/Timestamp);
Z8_Line5MAX=M*repmat([VC_Line1(1:end-1,1);0],1,(ETime-STime)/Timestamp);

QArrival12=sdpvar(totaltrain1,CommonStop);
Waittime12=sdpvar(totaltrain1,CommonStop);
QArrival52=sdpvar(totaltrain5,CommonStop);
Waittime52=sdpvar(totaltrain5,CommonStop);
%%%根据设定的三号线长交路、四号线、三号线短交路、四号线的开行方案，可以直接得到列车的前车与后车，计算所需间隔

for i=1:2:totaltrain1-1
    kk=(i-1)*CommonStop;
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                Z3_Line1(kk,m)=Z4_Line1(kk,m)+180;
            else 
                Z3_Line1(kk,m)=Z4_Line1(kk,m)+Departure1(i,k)-Departure5((i-1)/2,k+2);
            end
        end
    end
end

for i=2:2:totaltrain1
    kk=(i-1)*CommonStop;
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z3_Line1(kk,m)=Z4_Line1(kk,m)+Departure1(i,k)-Departure1(i-1,k);
        end
    end
end

for i=1:totaltrain5
    kk=(i-1)*CommonStop;
    for k=18:25
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z3_Line5(kk,m)=Z4_Line5(kk,m)+Departure5(i,k)-Departure1(2*i,k-2);
        end
    end
end

%%%生成共线段的Arrivalshare到达
kk=0;
for i=1:2:totaltrain1-1
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            try
                Z5_Line1(kk,m)=Z6_Line1(kk,m)+0.5*ArrivalRateShare(k-15,m)*Z3_Line5((i-3)*4+k-15,m);
            catch
            end
            QArrival_Line1(i,k)=QArrival_Line1(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m);
            if i==1
                if m==1
                QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-15,m);
                Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2;
                else
                QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m);
                Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2;
                end
            else
            if m==1
                QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m);
                Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2+Z5_Line1(kk,m)*Z3_Line5((i-3)*4+k-15,m)/2;
            else
                QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m);
                Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2+Z5_Line1(kk,m)*Z3_Line5((i-3)*4+k-15,m)/2;
            end
            end
        end
    end
end
kk=0;
for i=2:2:totaltrain1
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z7_Line1(kk,m)=Z8_Line1(kk,m)+0.5*ArrivalRateShare(k-15,m)*Z3_Line1(kk,m);
            QArrival_Line1(i,k)=QArrival_Line1(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)-Z7_Line1(kk,m);
            if m==1
                QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            else
                QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            end
        end
    end
end

kk=0;
for i=1:totaltrain5
    for k=18:25
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z5_Line5(kk,m)=Z6_Line5(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line1((2*i-2)*8+k-9,m);
            Z7_Line5(kk,m)=Z8_Line5(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line5(kk,m);
            QArrival_Line5(i,k)=QArrival_Line5(i,k)+Z3_Line5(kk,m)*ArrivalRateShare(k-17,m)+Z5_Line5(kk,m)-Z7_Line5(kk,m);
            if m==1
                QArrival52(i,k)=Z3_Line5(kk,m)*ArrivalRateShare(k-17,m)+Z5_Line5(kk,m)-Z7_Line5(kk,m);
                Waittime52(i,k)=Z3_Line5(kk,m)*Z3_Line5(kk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line5(kk,m)*Z3_Line1((2*i-2)*8+k-9,m)/2-Z7_Line5(kk,m)*Z3_Line5(kk,m)/2;
            else
                QArrival52(i,k)=QArrival52(i,k)+Z3_Line5(kk,m)*ArrivalRateShare(k-17,m)+Z5_Line5(kk,m)-Z7_Line5(kk,m);
                Waittime52(i,k)=Waittime52(i,k)+Z3_Line5(kk,m)*Z3_Line5(kk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line5(kk,m)*Z3_Line1((2*i-2)*8+k-9,m)/2-Z7_Line5(kk,m)*Z3_Line5(kk,m)/2;
            end
        end
    end
end
