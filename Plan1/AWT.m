%% This code is used to calculate passengers' average waiting time after Main.m. 

Waittime11=double(Waittime11);
Waittime12=double(Waittime12);
Waittime21=double(Waittime21);
Waittime22=double(Waittime22);
Waittime11(isnan(Waittime11))=0;
Waittime12(isnan(Waittime12))=0;
Waittime21(isnan(Waittime21))=0;
Waittime22(isnan(Waittime22))=0;
Strandedtime=0;
for i=1:size(double(Qstranded_line1_left),1)-1
    for j=1:size(double(Qstranded_line1_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line1_left(i,j))*(Departure1(i+1,j)-Departure1(i,j));
    end
end
for i=1:size(double(Qstranded_line2_left),1)-1
    for j=1:size(double(Qstranded_line2_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line2_left(i,j))*(Departure2(i+1,j)-Departure2(i,j));
    end
end
AverageWaittime=(sum(sum(Waittime11))+sum(sum(Waittime12))+sum(sum(Waittime21))+sum(sum(Waittime22))+Strandedtime)/(sum(sum(double(Qboard_line1_left)))+sum(sum(double(Qboard_line2_left))));
