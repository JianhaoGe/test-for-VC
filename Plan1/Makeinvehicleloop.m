function [Qinvehicle_line2_right,ZZ1,ZZ1max,ZZ1min,ZZ2,ZZ2max,ZZ2min] = Makeinvehicleloop(Qboard_line2_left,Qalight_line2_left,arf3)
s=size(Qboard_line2_left);
totaltrain2=s(1,1);
totalstation2=s(1,2)+1;
M=99999;

Qinvehicle_line2_right=sdpvar(totaltrain2,totalstation2);

%% PAM is used here to make ZZ1(j,1)=Qinvehicle_line2_right(i,totalstation2) when arf3(i,j)==1.

ZZ1=sdpvar(totaltrain2,totaltrain2);
ZZ1max=M*arf3;
ZZ1min=-M*arf3;

ZZ2=sdpvar(totaltrain2,totaltrain2);
ZZ2max=M*(1-arf3);
ZZ2min=-M*(1-arf3);
%% Constraint (48-50)
%% According to the train connection relationship, if two trains of Line 2 are connected, the passenger information of the following train in the starting station inherits the front train at its ending station, otherwise all the number of passengers are 0.
Qinvehicle_line2_right(:,1)=0;
for k=2:totalstation2
    Qinvehicle_line2_right(1,k)=Qinvehicle_line2_right(1,k-1)+Qboard_line2_left(1,k-1)-Qalight_line2_left(1,k);
end
for i=2:totaltrain2
    %% Note: Code ommited
    Qinvehicle_line2_right(i,1)=sum(ZZ1(:,i));
    for k=2:totalstation2
        Qinvehicle_line2_right(i,k)=Qinvehicle_line2_right(i,k-1)+Qboard_line2_left(i,k-1)-Qalight_line2_left(i,k);
    end
end
