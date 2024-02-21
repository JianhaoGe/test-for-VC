function [Qwait_line1_right,Qwait_line3_right] = Makewait13(QArrival_Line1_left,Qstranded_line1_left,QArrival_Line3_left,Qstranded_line3_left)
s1=size(QArrival_Line1_left);
totaltrain1=s1(1,1);
totalstation1=s1(1,2)+1;
s2=size(QArrival_Line3_left);
totaltrain3=s2(1,1);
totalstation3=s2(1,2)+1;
Qwait_line1_right(1,:)=QArrival_Line1_left(1,:);
Qwait_line1_right(2:totaltrain1,1:8)=QArrival_Line1_left(2:end,1:8)+Qstranded_line1_left(1:end-1,1:8);
Qwait_line1_right(2:totaltrain1,9:totalstation1-1)=QArrival_Line1_left(2:end,9:end)+Qstranded_line3_left(1:end-1,:);

Qwait_line3_right=QArrival_Line3_left+Qstranded_line1_left(:,9:end);