function [Qinvehicle_line5_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicle5(Qboard_line5_left,Qalight_line5_left,arf3)
s=size(Qboard_line5_left);
totaltrain5=s(1,1);
totalstation5=s(1,2)+1;
M=99999;

Qinvehicle_line5_right=sdpvar(totaltrain5,totalstation5);

ZZ1=sdpvar(totaltrain5,totaltrain5);
ZZ1max=M*arf3;
ZZ1min=-M*arf3;

ZZ2=sdpvar(totaltrain5,totaltrain5);
ZZ2max=M*(1-arf3);
ZZ2min=-M*(1-arf3);
%%%根据套跑情况，若两列车套跑，则后车在起始站的车内乘客信息继承所套跑的列车，否则为0
%%%此处ZZ1为套跑决策变量*车内乘客数量的非线性变量线性化过程
Qinvehicle_line5_right(:,1)=0;
for k=2:27
    Qinvehicle_line5_right(1,k)=Qinvehicle_line5_right(1,k-1)+Qboard_line5_left(1,k-1)-Qalight_line5_left(1,k);
end
for i=2:totaltrain5
    for j=1:i-1
        ZZ1(j,i)=ZZ2(j,i)+Qinvehicle_line5_right(j,totalstation5);
    end
    for j=i:20
        ZZ1(j,i)=0;
        ZZ2(j,i)=0;
    end
    Qinvehicle_line5_right(i,1)=sum(ZZ1(:,i));
    for k=2:totalstation5
        Qinvehicle_line5_right(i,k)=Qinvehicle_line5_right(i,k-1)+Qboard_line5_left(i,k-1)-Qalight_line5_left(i,k);
    end
end
