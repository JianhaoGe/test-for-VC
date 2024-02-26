function Qinvehicle_right = Makeinvehicle(Qboard_left,Qalight_left)
s=size(Qboard_left);
totaltrain=s(1,1);
totalstation=s(1,2)+1;

%% Constraints (26-27,29)
Qinvehicle_right=sdpvar(totaltrain,totalstation);

Qinvehicle_right(:,1)=zeros(totaltrain,1);
for i=2:totalstation
    Qinvehicle_right(:,i)=Qinvehicle_right(:,i-1)+Qboard_left(:,i-1)-Qalight_left(:,i);
end
