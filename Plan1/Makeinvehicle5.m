function [Qinvehicle_line5_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicleloop(Qboard_line5_left,Qalight_line5_left,arf3)
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
%%According to the train connection relationship, if two trains of Line5 are connected, the passenger information of the following train in the starting station inherits the front train at its ending station, otherwise all the number of passengers are 0.
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
