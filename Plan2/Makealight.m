function [Qalight_Line1_right,Qalight_Line3_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max,Z9_Line1,Z9_Line1MIN,Z9_Line1MAX,Z9_Line3,Z9_Line3MIN,Z9_Line3MAX,Z9_Line5,Z9_Line5MIN,Z9_Line5MAX,Z10_Line1,Z10_Line1MIN,Z10_Line1MAX,Z10_Line3,Z10_Line3MIN,Z10_Line3MAX,Z10_Line5,Z10_Line5MIN,Z10_Line5MAX,XX5,XX5min,XX5max]=Makealight(Departure1,Qboard_line1_left,Alightpercent1,Departure3,Qboard_line3_left,Alightpercent3,Departure5,Qboard_line5_left,Alightpercent5,arf3,X3_Line1,X3_Line3,X3_Line5,Etime,Stime,Timestamp)
M=99999;
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s3=size(Departure3);
totaltrain3=s3(1,1);
totalstation3=s3(1,2);
s5=size(Departure5);
totaltrain5=s5(1,1);
totalstation5=s5(1,2);


Qalight_Line1_right=sdpvar(totaltrain1,totalstation1);
Qalight_Line3_right=sdpvar(totaltrain3,totalstation3);
Qalight_Line5_right=sdpvar(totaltrain5,totalstation5);

Z9_Line1=sdpvar(totaltrain1*(totalstation1-1),(Etime-Stime)/Timestamp);
Z9_Line1MIN=-M*X3_Line1;
Z9_Line1MAX=M*X3_Line1;

Z9_Line3=sdpvar(totaltrain3*(totalstation3-1),(Etime-Stime)/Timestamp);
Z9_Line3MIN=-M*X3_Line3;
Z9_Line3MAX=M*X3_Line3;

Z9_Line5=sdpvar(totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
Z9_Line5MIN=-M*X3_Line5;
Z9_Line5MAX=M*X3_Line5;

Z10_Line1=sdpvar(totaltrain1*(totalstation1-1),(Etime-Stime)/Timestamp);
Z10_Line1MIN=-M*(1-X3_Line1);
Z10_Line1MAX=M*(1-X3_Line1);

Z10_Line3=sdpvar(totaltrain3*(totalstation3-1),(Etime-Stime)/Timestamp);
Z10_Line3MIN=-M*(1-X3_Line3);
Z10_Line3MAX=M*(1-X3_Line3);

Z10_Line5=sdpvar(totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
Z10_Line5MIN=-M*(1-X3_Line5);
Z10_Line5MAX=M*(1-X3_Line5);
%%%在预处理时生成Alightpercent，其意义为以在时段m到达车站k，目的地为车站j的乘客在同时段到达车站k的乘客中的占比
%%%在共线段，其到达乘客为该时段的QArrivalOnly+0.5*QArrivalShare人数，占比也相应得出
for i=1:totaltrain1
    for j=2:totalstation1
        for k=1:totalstation1-1
            cc=(i-1)*(totalstation1-1)+k;
            for m=1:(Etime-Stime)/Timestamp
                Z10_Line1(cc,m)=Z9_Line1(cc,m)-Qboard_line1_left(i,k);
                if k==1
                    Qalight_Line1_right(i,j)=Alightpercent1(k,j-1,m)*Z9_Line1(cc,m);
                else
                    Qalight_Line1_right(i,j)=Qalight_Line1_right(i,j)+Alightpercent1(k,j-1,m)*Z9_Line1(cc,m);
                end
            end
        end
    end
end

for i=1:totaltrain3
    for j=2:totalstation3
        for k=1:totalstation3-1
            cc=(i-1)*(totalstation3-1)+k;
            for m=1:(Etime-Stime)/Timestamp
                Z10_Line3(cc,m)=Z9_Line3(cc,m)-Qboard_line3_left(i,k);
                if k==1
                    Qalight_Line3_right(i,j)=Alightpercent3(k,j-1,m)*Z9_Line3(cc,m);
                else
                    Qalight_Line3_right(i,j)=Qalight_Line3_right(i,j)+Alightpercent3(k,j-1,m)*Z9_Line3(cc,m);
                end
            end
        end
    end
end

for i=1:totaltrain5
    for j=2:totalstation5
        for k=1:j-1
            cc=(i-1)*(totalstation5-1)+k;
            for m=1:(Etime-Stime)/Timestamp
                Z10_Line5(cc,m)=Z9_Line5(cc,m)-Qboard_line5_left(i,k);
                if k==1
                    Qalight_Line5_right(i,j)=Alightpercent5(k,j-1,m)*Z9_Line5(cc,m);
                else
                    Qalight_Line5_right(i,j)=Qalight_Line5_right(i,j)+Alightpercent5(k,j-1,m)*Z9_Line5(cc,m);
                end
            end
        end
    end
end     

%%%针对四号线套跑建立套跑情况下的上次车内剩余乘客的下车，先建立0-1变量以判断列车i套跑列车ii，且在m时刻到达k站，再计算套跑前乘客下车
%%%需优化，计算极慢
XX5=binvar(totaltrain5*totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
XX5min=sdpvar(totaltrain5*totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
XX5max=sdpvar(totaltrain5*totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);

cc=0;
for i=1:totaltrain5
    ccc=0;
    for ii=1:totaltrain5
        for k=totalstation5-1
            cc=cc+1;
            ccc=ccc+1;
            for m=(Etime-Stime)/Timestamp
                XX5min(cc,m)=(arf3(ii,i)+X3_Line5(ccc,m)-1.5)/M;
                XX5max(cc,m)=(arf3(ii,i)+X3_Line5(ccc,m)-1.5)/M+1;
            end
        end
    end
end
ZZ3=sdpvar(totaltrain5*totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
ZZ3min=-M*XX5;
ZZ3max=M*XX5;

ZZ4=sdpvar(totaltrain5*totaltrain5*(totalstation5-1),(Etime-Stime)/Timestamp);
ZZ4min=-M*(1-XX5);
ZZ4max=M*(1-XX5);

cc=0;
for i=1:totaltrain5
    for ii=1:totaltrain5
        cc=cc+1;
        for j=2:totalstation5
            for k=j+1:totalstation5-1
                ccc=(cc-1)*(totalstation5-1)+k;
                for m=1:(Etime-Stime)/Timestamp
                    ZZ4(ccc,m)=ZZ3(ccc,m)-Qboard_line5_left(ii,k);
                    Qalight_Line5_right(i,j)=Qalight_Line5_right(i,j)+Alightpercent5(k,j-1,m)*ZZ3(ccc,m);
                end
            end
        end
    end
end     

