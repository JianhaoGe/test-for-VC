%%%This code is used to calculate passengers' average waiting time. 

Waittime11=double(Waittime11);
Waittime12=double(Waittime12);
Waittime51=double(Waittime51);
Waittime52=double(Waittime52);
Waittime11(isnan(Waittime11))=0;
Waittime12(isnan(Waittime12))=0;
Waittime51(isnan(Waittime51))=0;
Waittime52(isnan(Waittime52))=0;
Strandedtime=0;
for i=1:size(double(Qstranded_line1_left),1)-1
    for j=1:size(double(Qstranded_line1_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line1_left(i,j))*(Departure1(i+1,j)-Departure1(i,j));
    end
end
for i=1:size(double(Qstranded_line5_left),1)-1
    for j=1:size(double(Qstranded_line5_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line5_left(i,j))*(Departure5(i+1,j)-Departure5(i,j));
    end
end
AverageWaittime=(sum(sum(Waittime11))+sum(sum(Waittime12))+sum(sum(Waittime51))+sum(sum(Waittime52))+Strandedtime)/(sum(sum(double(Qboard_line1_left)))+sum(sum(double(Qboard_line5_left))));