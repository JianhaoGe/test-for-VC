load('套跑6，滞留最小，当前客流分配结果112.mat');
% load('套跑6，滞留最小，超倍客流分配结果112.mat');
FLR1=(Qinvehicle_line1_left(:,1:end-1)+Qboard_line1_left)/340/6;
FLR3=(Qinvehicle_line3_left(:,1:end-1)+Qboard_line3_left)/340/6;
FLR5=(Qinvehicle_line5_left(:,1:end-1)+Qboard_line5_left)/340/6;
averageFLR3112=zeros(1,28);
averageFLR3=sum(FLR1);
averageFLR3(:,9:end)=averageFLR3(:,9:end)+sum(FLR3,1);
averageFLR3112(:,1:8)=averageFLR3(:,1:8)/size(FLR3,1);
averageFLR3112(:,9:end)=averageFLR3(:,9:end)/(size(FLR1,1)+size(FLR3,1));
averageFLR4112=sum(FLR5)/(size(FLR5,1));


FLR1=double(FLR1);
FLR3=double(FLR3);
FLR5=double(FLR5);
NumFLR=sum(sum(FLR1>1))+sum(sum(FLR3>1))+sum(sum(FLR5>1));
AFLR=(sum(sum(FLR1))+sum(sum(FLR3))+sum(sum(FLR5)))/(size(FLR1,1)*size(FLR1,2)+size(FLR3,1)*size(FLR3,2)+size(FLR5,1)*size(FLR5,2));
Numstranded=sum(sum(double(Qstranded_line1_left)))+sum(sum(double(Qstranded_line3_left)))+sum(sum(double(Qstranded_line5_left)));