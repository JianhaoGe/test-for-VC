function [Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line3,Z3_Line3MIN,Z3_Line3MAX,Z4_Line3,Z4_Line3MIN,Z4_Line3MAX,Z5_Line3,Z5_Line3MIN,Z5_Line3MAX,Z6_Line3,Z6_Line3MIN,Z6_Line3MAX,Z7_Line3,Z7_Line3MIN,Z7_Line3MAX,Z8_Line3,Z8_Line3MIN,Z8_Line3MAX,Z3_Line5,Z3_Line5MIN,Z3_Line5MAX,Z4_Line5,Z4_Line5MIN,Z4_Line5MAX,Z5_Line51,Z5_Line51MIN,Z5_Line51MAX,Z5_Line52,Z5_Line52MIN,Z5_Line52MAX,Z6_Line51,Z6_Line51MIN,Z6_Line51MAX,Z6_Line52,Z6_Line52MIN,Z6_Line52MAX,Z7_Line51,Z7_Line51MIN,Z7_Line51MAX,Z7_Line52,Z7_Line52MIN,Z7_Line52MAX,Z8_Line51,Z8_Line51MIN,Z8_Line51MAX,Z8_Line52,Z8_Line52MIN,Z8_Line52MAX,QArrival_Line1,QArrival_Line3,QArrival_Line5,QArrival12,QArrival32,QArrival52,Waittime12,Waittime32,Waittime52]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line3,QArrival_Line5,X3_Line1,X3_Line3,X3_Line5,Departure1,Departure3,Departure5,ETime,STime,Timestamp,VCor15,VCor35)
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
CommonStop=8;
%%%生成三四号线共线段的间隔参数
Z3_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
za1=[];
for i=1:totaltrain1
    za1=[za1,(i-1)*(totalstation1-1)+16:(i-1)*(totalstation1-1)+23];
end
Z3_Line1MIN=-M*X3_Line1(za1,:);
Z3_Line1MAX=M*X3_Line1(za1,:);

Z3_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
za3=[];
for i=1:totaltrain3
    za3=[za3,(i-1)*(totalstation3-1)+8:(i-1)*(totalstation3-1)+15];
end
Z3_Line3MIN=-M*X3_Line3(za3,:);
Z3_Line3MAX=M*X3_Line3(za3,:);

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

Z4_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line3MIN=-M*(1-X3_Line3(za3,:));
Z4_Line3MAX=M*(1-X3_Line3(za3,:));

Z4_Line5=sdpvar(totaltrain5*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line5MIN=-M*(1-X3_Line5(za5,:));
Z4_Line5MAX=M*(1-X3_Line5(za5,:));

%%%生成三四号线共线段是否虚拟编组的相关参数，四号线被分割为了前车为三号线长交路与前车为三号线短交路两种情况
%%%此处为模型的线性化
%%%若与前车进行虚拟编组，则到达乘客数加上Z5

cc=0;
for i=1:totaltrain1
    for j=1:CommonStop
        cc=cc+1;
        VC_Line1(cc,1)=VCor15(i,2);
    end
end
Z5_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line1MIN=-M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));
Z5_Line1MAX=M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));

cc=0;
for i=1:totaltrain3
    for j=1:CommonStop
        cc=cc+1;
        VC_Line3(cc,1)=VCor35(i,2);
    end
end
Z5_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line3MIN=-M*(1-repmat(VC_Line3,1,(ETime-STime)/Timestamp));
Z5_Line3MAX=M*(1-repmat(VC_Line3,1,(ETime-STime)/Timestamp));

cc=0;
for i=1:totaltrain5/2
    for j=1:CommonStop
        cc=cc+1;
        VC_Line51(cc,1)=VCor15(i,1);
    end
end
Z5_Line51=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line51MIN=-M*(1-repmat(VC_Line51,1,(ETime-STime)/Timestamp));
Z5_Line51MAX=M*(1-repmat(VC_Line51,1,(ETime-STime)/Timestamp));

cc=0;
for i=1:totaltrain5/2
    for j=1:CommonStop
        cc=cc+1;
        VC_Line52(cc,1)=VCor35(i,1);
    end
end
Z5_Line52=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line52MIN=-M*(1-repmat(VC_Line52,1,(ETime-STime)/Timestamp));
Z5_Line52MAX=M*(1-repmat(VC_Line52,1,(ETime-STime)/Timestamp));

Z6_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line1MIN=-M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);
Z6_Line1MAX=M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);

Z6_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line3MIN=-M*repmat(VC_Line3,1,(ETime-STime)/Timestamp);
Z6_Line3MAX=M*repmat(VC_Line3,1,(ETime-STime)/Timestamp);

Z6_Line51=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line51MIN=-M*repmat(VC_Line51,1,(ETime-STime)/Timestamp);
Z6_Line51MAX=M*repmat(VC_Line51,1,(ETime-STime)/Timestamp);

Z6_Line52=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line52MIN=-M*repmat(VC_Line52,1,(ETime-STime)/Timestamp);
Z6_Line52MAX=M*repmat(VC_Line52,1,(ETime-STime)/Timestamp);

%%%若与后车进行虚拟编组则到达乘客数加上Z7
Z7_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line1MIN=-M*(1-repmat(VC_Line51,1,(ETime-STime)/Timestamp));
Z7_Line1MAX=M*(1-repmat(VC_Line51,1,(ETime-STime)/Timestamp));

Z7_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line3MIN=-M*(1-repmat(VC_Line52,1,(ETime-STime)/Timestamp));
Z7_Line3MAX=M*(1-repmat(VC_Line52,1,(ETime-STime)/Timestamp));

Z7_Line51=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line51MIN=-M*(1-repmat(VC_Line3,1,(ETime-STime)/Timestamp));
Z7_Line51MAX=M*(1-repmat(VC_Line3,1,(ETime-STime)/Timestamp));

Z7_Line52=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line52MIN=-M*(1-repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp));
Z7_Line52MAX=M*(1-repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp));

Z8_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line1MIN=-M*repmat(VC_Line51,1,(ETime-STime)/Timestamp);
Z8_Line1MAX=M*repmat(VC_Line51,1,(ETime-STime)/Timestamp);

Z8_Line3=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line3MIN=-M*repmat(VC_Line52,1,(ETime-STime)/Timestamp);
Z8_Line3MAX=M*repmat(VC_Line52,1,(ETime-STime)/Timestamp);

Z8_Line51=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line51MIN=-M*repmat(VC_Line3,1,(ETime-STime)/Timestamp);
Z8_Line51MAX=M*repmat(VC_Line3,1,(ETime-STime)/Timestamp);

Z8_Line52=sdpvar(totaltrain3*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line52MIN=-M*repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp);
Z8_Line52MAX=M*repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp);

QArrival12=sdpvar(totaltrain1,CommonStop);
Waittime12=sdpvar(totaltrain1,CommonStop);
QArrival32=sdpvar(totaltrain3,CommonStop);
Waittime32=sdpvar(totaltrain3,CommonStop);
QArrival52=sdpvar(totaltrain5,CommonStop);
Waittime52=sdpvar(totaltrain5,CommonStop);
%%%根据设定的三号线长交路、四号线、三号线短交路、四号线的开行方案，可以直接得到列车的前车与后车，计算所需间隔
kk=0;
for i=1:totaltrain1
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            if i==1
                Z3_Line1(kk,m)=Z4_Line1(kk,m)+180;
            else 
                Z3_Line1(kk,m)=Z4_Line1(kk,m)+Departure1(i,k)-Departure5(2*i-2,k+2);
            end
        end
    end
end
kk=0;
for i=1:totaltrain3
    for k=8:15
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z3_Line3(kk,m)=Z4_Line3(kk,m)+Departure3(i,k)-Departure5(2*i-1,k+10);
        end
    end
end

for i=1:2:totaltrain5-1
    kk=(i-1)*CommonStop;
    for k=18:25
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z3_Line5(kk,m)=Z4_Line5(kk,m)+Departure5(i,k)-Departure1((i+1)/2,k-2);
        end
    end
end
for i=2:2:totaltrain5
    kk=(i-1)*CommonStop;
    for k=18:25
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z3_Line5(kk,m)=Z4_Line5(kk,m)+Departure5(i,k)-Departure3(i/2,k-10);
        end
    end
end

%%%生成共线段的Arrivalshare到达
kk=0;
for i=1:totaltrain1
    for k=16:23
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            try
                Z5_Line1(kk,m)=Z6_Line1(kk,m)+0.5*ArrivalRateShare(k-15,m)*Z3_Line5((i-2)*16+k-7,m);
            catch
            end
            Z7_Line1(kk,m)=Z8_Line1(kk,m)+0.5*ArrivalRateShare(k-15,m)*Z3_Line1(kk,m);
            QArrival_Line1(i,k)=QArrival_Line1(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
            if i==1
                if m==1
                    QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)-Z7_Line1(kk,m);
                    Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
                else 
                    QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)-Z7_Line1(kk,m);
                    Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
                end
            else
            if m==1
                QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2+Z5_Line1(kk,m)*Z3_Line5((i-2)*16+k-7,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            else
                QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-15,m)/2+Z5_Line1(kk,m)*Z3_Line5((i-2)*16+k-7,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            end
            end
        end
    end
end

kk=0;
for i=1:totaltrain3
    for k=8:15
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            Z5_Line3(kk,m)=Z6_Line3(kk,m)+0.5*ArrivalRateShare(k-7,m)*Z3_Line5((i-1)*16+k-7,m);
            Z7_Line3(kk,m)=Z8_Line3(kk,m)+0.5*ArrivalRateShare(k-7,m)*Z3_Line3(kk,m);
            QArrival_Line3(i,k)=QArrival_Line3(i,k)+Z3_Line3(kk,m)*ArrivalRateShare(k-7,m)+Z5_Line3(kk,m)-Z7_Line3(kk,m);
            if m==1
                QArrival32(i,k)=Z3_Line3(kk,m)*ArrivalRateShare(k-7,m)+Z5_Line3(kk,m)-Z7_Line3(kk,m);
                Waittime32(i,k)=Z3_Line3(kk,m)*Z3_Line3(kk,m)*ArrivalRateShare(k-7,m)/2+Z5_Line3(kk,m)*Z3_Line5((i-1)*16+k-7,m)/2-Z7_Line3(kk,m)*Z3_Line3(kk,m)/2;
            else
                QArrival32(i,k)=QArrival32(i,k)+Z3_Line3(kk,m)*ArrivalRateShare(k-7,m)+Z5_Line3(kk,m)-Z7_Line3(kk,m);
                Waittime32(i,k)=Waittime32(i,k)+Z3_Line3(kk,m)*Z3_Line3(kk,m)*ArrivalRateShare(k-7,m)/2+Z5_Line3(kk,m)*Z3_Line5((i-1)*16+k-7,m)/2-Z7_Line3(kk,m)*Z3_Line3(kk,m)/2;
            end
        end
    end
end

kk=0;
for i=1:2:totaltrain5-1
    kkk=(i-1)*CommonStop;
    for k=18:25
        kk=kk+1;
        kkk=kkk+1;
        for m=1:(ETime-STime)/Timestamp
            Z5_Line51(kk,m)=Z6_Line51(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line1(kk,m);
            Z7_Line51(kk,m)=Z8_Line51(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line5(kkk,m);
            QArrival_Line5(i,k)=QArrival_Line5(i,k)+Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line51(kk,m)-Z7_Line51(kk,m);
            if m==1
                QArrival52(i,k)=Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line51(kk,m)-Z7_Line51(kk,m);
                Waittime52(i,k)=Z3_Line5(kkk,m)*Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line51(kk,m)*Z3_Line1(kk,m)/2-Z7_Line51(kk,m)*Z3_Line5(kkk,m)/2;
            else
                QArrival52(i,k)=QArrival52(i,k)+Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line51(kk,m)-Z7_Line51(kk,m);
                Waittime52(i,k)=Waittime52(i,k)+Z3_Line5(kkk,m)*Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line51(kk,m)*Z3_Line1(kk,m)/2-Z7_Line51(kk,m)*Z3_Line5(kkk,m)/2;
            end
        end
    end
end

kk=0;
for i=2:2:totaltrain5
    kkk=(i-1)*CommonStop;
    for k=18:25
        kk=kk+1;
        kkk=kkk+1;
        for m=1:(ETime-STime)/Timestamp
            Z5_Line52(kk,m)=Z6_Line52(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line3(kk,m);
            Z7_Line52(kk,m)=Z8_Line52(kk,m)+0.5*ArrivalRateShare(k-17,m)*Z3_Line5(kkk,m);
            QArrival_Line5(i,k)=QArrival_Line5(i,k)+Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line52(kk,m)-Z7_Line52(kk,m);
            if m==1
                QArrival52(i,k)=Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line52(kk,m)-Z7_Line52(kk,m);
                Waittime52(i,k)=Z3_Line5(kkk,m)*Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line52(kk,m)*Z3_Line3(kk,m)/2-Z7_Line52(kk,m)*Z3_Line5(kkk,m)/2;
            else
                QArrival52(i,k)=QArrival52(i,k)+Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)+Z5_Line52(kk,m)-Z7_Line52(kk,m);
                Waittime52(i,k)=Waittime52(i,k)+Z3_Line5(kkk,m)*Z3_Line5(kkk,m)*ArrivalRateShare(k-17,m)/2+Z5_Line52(kk,m)*Z3_Line3(kk,m)/2-Z7_Line52(kk,m)*Z3_Line5(kkk,m)/2;
            end
        end
    end
end