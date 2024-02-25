function [Z3_Line1,Z3_Line1MIN,Z3_Line1MAX,Z4_Line1,Z4_Line1MIN,Z4_Line1MAX,Z5_Line1,Z5_Line1MIN,Z5_Line1MAX,Z6_Line1,Z6_Line1MIN,Z6_Line1MAX,Z7_Line1,Z7_Line1MIN,Z7_Line1MAX,Z8_Line1,Z8_Line1MIN,Z8_Line1MAX,Z3_Line2,Z3_Line2MIN,Z3_Line2MAX,Z4_Line2,Z4_Line2MIN,Z4_Line2MAX,Z2_Line2,Z2_Line2MIN,Z2_Line2MAX,Z6_Line2,Z6_Line2MIN,Z6_Line2MAX,Z7_Line2,Z7_Line2MIN,Z7_Line2MAX,Z8_Line2,Z8_Line2MIN,Z8_Line2MAX,QArrival_Line1,QArrival_Line2,QArrival12,QArrival22,Waittime12,Waittime22]=MakeShareArrival(ArrivalRateShare,QArrival_Line1,QArrival_Line2,X3_Line1,X3_Line2,Departure1,Departure2,ETime,STime,Timestamp,VCor12,Sharestation,Fcommonstop1,Fcommonstop2)
M=10^8;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s2=size(Departure2);
totaltrain2=s2(1,1);
totalstation2=s2(1,2);
CommonStop=Sharestation-1;

%% Generate train intervals between Line 1 and Line 2 at stations on the collinear corridor with the same method as MakeOnlyArrival.

Z3_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
za1=[];
for i=1:totaltrain1
    za1=[za1,(i-1)*(totalstation1-1)+16:(i-1)*(totalstation1-1)+23];
end
Z3_Line1MIN=-M*X3_Line1(za1,:);
Z3_Line1MAX=M*X3_Line1(za1,:);

Z3_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
za2=[];
for i=1:totaltrain2
    za2=[za2,(i-1)*(totalstation2-1)+18:(i-1)*(totalstation2-1)+22];
end
Z3_Line2MIN=-M*X3_Line2(za2,:);
Z3_Line2MAX=M*X3_Line2(za2,:);

Z4_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line1MIN=-M*(1-X3_Line1(za1,:));
Z4_Line1MAX=M*(1-X3_Line1(za1,:));

Z4_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
Z4_Line2MIN=-M*(1-X3_Line2(za2,:));
Z4_Line2MAX=M*(1-X3_Line2(za2,:));

%% Note: codes omitted.

%% If it is virtually coupled with its front train, the number of arriving passenger needs to add Z5 as it is shown in Constraint 21.
%% If it is virtually coupled with its rear train, the number of arriving passenger needs to add Z7.
%% The decision variable is VC_Line1 and VC_Line2.
%% Z5 equals half of the number of arriving passenger of its front train.
%% Z7 equals minus half of the negative number of arriving passenger of itself.

cc=0;
for i=1:totaltrain1
    for j=1:CommonStop
        cc=cc+1;
        VC_Line1(cc,1)=VCor12(i,2);
    end
end

cc=0;
for i=1:totaltrain2
    for j=1:CommonStop
        cc=cc+1;
        VC_Line2(cc,1)=VCor12(i,1);
    end
end

Z5_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line1MIN=-M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));
Z5_Line1MAX=M*(1-repmat(VC_Line1,1,(ETime-STime)/Timestamp));

Z5_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
Z5_Line2MIN=-M*(1-repmat(VC_Line2,1,(ETime-STime)/Timestamp));
Z5_Line2MAX=M*(1-repmat(VC_Line2,1,(ETime-STime)/Timestamp));

Z6_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line1MIN=-M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);
Z6_Line1MAX=M*repmat(VC_Line1,1,(ETime-STime)/Timestamp);

Z6_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
Z6_Line2MIN=-M*repmat(VC_Line2,1,(ETime-STime)/Timestamp);
Z6_Line2MAX=M*repmat(VC_Line2,1,(ETime-STime)/Timestamp);

Z7_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line1MIN=-M*(1-repmat(VC_Line2,1,(ETime-STime)/Timestamp));
Z7_Line1MAX=M*(1-repmat(VC_Line2,1,(ETime-STime)/Timestamp));

Z7_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
Z7_Line2MIN=-M*(1-repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp));
Z7_Line2MAX=M*(1-repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp));

Z8_Line1=sdpvar(totaltrain1*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line1MIN=-M*repmat(VC_Line2,1,(ETime-STime)/Timestamp);
Z8_Line1MAX=M*repmat(VC_Line2,1,(ETime-STime)/Timestamp);

Z8_Line2=sdpvar(totaltrain2*(CommonStop),(ETime-STime)/Timestamp);
Z8_Line2MIN=-M*repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp);
Z8_Line2MAX=M*repmat([VC_Line1(2:end,1);0],1,(ETime-STime)/Timestamp);

%% The following variables are used to analyze the passenger service quality, which are not constrained in the model.
QArrival12=sdpvar(totaltrain1,CommonStop);
Waittime12=sdpvar(totaltrain1,CommonStop);
QArrival22=sdpvar(totaltrain2,CommonStop);
Waittime22=sdpvar(totaltrain2,CommonStop);

%% Generate the arriving passengers who can both take trains of Line 1 and Line 2
kk=0;
for i=1:totaltrain1
    for k=Fcommonstop1:Fcommonstop1+CommonStop
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            %% Note: code omitted.
            QArrival_Line1(i,k)=QArrival_Line1(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
            if i==1
                if m==1
                    QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)-Z7_Line1(kk,m);
                    Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
                else
                    QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)-Z7_Line1(kk,m);
                    Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
                end
            else
            if m==1
                QArrival12(i,k)=Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)/2+Z5_Line1(kk,m)*Z3_Line2((i-2)*CommonStop+k-Fcommonstop1+1,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            else
                QArrival12(i,k)=QArrival12(i,k)+Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)+Z5_Line1(kk,m)-Z7_Line1(kk,m);
                Waittime12(i,k)=Waittime12(i,k)+Z3_Line1(kk,m)*Z3_Line1(kk,m)*ArrivalRateShare(k-Fcommonstop1+1,m)/2+Z5_Line1(kk,m)*Z3_Line2((i-2)*CommonStop+k-Fcommonstop1+1,m)/2-Z7_Line1(kk,m)*Z3_Line1(kk,m)/2;
            end
            end
        end
    end
end

kk=0;
for i=1:totaltrain2
    for k=Fcommonstop2:Fcommonstop2+CommonStop
        kk=kk+1;
        for m=1:(ETime-STime)/Timestamp
            %% Note: code omitted.
            QArrival_Line2(i,k)=QArrival_Line2(i,k)+Z3_Line2(kk,m)*ArrivalRateShare(k-Fcommonstop2+1,m)+Z5_Line2(kk,m)-Z7_Line2(kk,m);
            if m==1
                QArrival22(i,k)=Z3_Line2(kk,m)*ArrivalRateShare(k-Fcommonstop2+1,m)+Z5_Line2(kk,m)-Z7_Line2(kk,m);
                Waittime22(i,k)=Z3_Line2(kk,m)*Z3_Line2(kk,m)*ArrivalRateShare(k-Fcommonstop2+1,m)/2+Z5_Line2(kk,m)*Z3_Line1(kk,m)/2-Z7_Line2(kk,m)*Z3_Line2(kk,m)/2;
            else
                QArrival22(i,k)=QArrival22(i,k)+Z3_Line2(kk,m)*ArrivalRateShare(k-Fcommonstop2+1,m)+Z5_Line2(kk,m)-Z7_Line2(kk,m);
                Waittime22(i,k)=Waittime22(i,k)+Z3_Line2(kk,m)*Z3_Line2(kk,m)*ArrivalRateShare(k-Fcommonstop2+1,m)/2+Z5_Line2(kk,m)*Z3_Line1(kk,m)/2-Z7_Line2(kk,m)*Z3_Line2(kk,m)/2;
            end
        end
    end
end
