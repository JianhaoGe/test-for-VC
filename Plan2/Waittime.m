Waittime11(isnan(Waittime11))=0;
Waittime12(isnan(Waittime12))=0;
Waittime31(isnan(Waittime31))=0;
Waittime32(isnan(Waittime32))=0;
Waittime51(isnan(Waittime51))=0;
Waittime52(isnan(Waittime52))=0;
Strandedtime=0;
for i=1:size(double(Qstranded_line1_left),1)-1
    for j=1:size(double(Qstranded_line1_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line1_left(i,j))*(Departure1(i+1,j)-Departure1(i,j));
    end
end
for i=1:size(double(Qstranded_line3_left),1)-1
    for j=1:size(double(Qstranded_line3_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line3_left(i,j))*(Departure3(i+1,j)-Departure3(i,j));
    end
end
for i=1:size(double(Qstranded_line5_left),1)-1
    for j=1:size(double(Qstranded_line5_left),2)
        Strandedtime=Strandedtime+double(Qstranded_line5_left(i,j))*(Departure5(i+1,j)-Departure5(i,j));
    end
end
AverageWaittime=(sum(sum(Waittime11))+sum(sum(Waittime12))+sum(sum(Waittime31))+sum(sum(Waittime32))+sum(sum(Waittime51))+sum(sum(Waittime52))+Strandedtime)/(sum(sum(double(Qboard_line1_left)))+sum(sum(double(Qboard_line3_left)))+sum(sum(double(Qboard_line5_left))));