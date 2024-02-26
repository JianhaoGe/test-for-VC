%% This code is used to calculate  average full load rate. 
load('result.mat');
FLR1=(Qinvehicle_line1_left(:,1:end-1)+Qboard_line1_left)/340/6;
FLR2=(Qinvehicle_line2_left(:,1:end-1)+Qboard_line2_left)/340/6;
averageFLR3=sum(FLR1);
averageFLR311=averageFLR3/(size(FLR1,1));
averageFLR411=sum(FLR2)/(size(FLR2,1));
FLR1=double(FLR1);
FLR2=double(FLR2);
NumFLR=sum(sum(FLR1>1))+sum(sum(FLR2>1));
AFLR=(sum(sum(FLR1))+sum(sum(FLR2)))/(size(FLR1,1)*size(FLR1,2)+size(FLR2,1)*size(FLR2,2));
Numstranded=sum(sum(double(Qstranded_line1_left)))+sum(sum(double(Qstranded_line2_left)));
