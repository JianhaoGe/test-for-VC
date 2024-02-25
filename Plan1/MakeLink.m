function [arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink5,AllRunningtime5] = MakeLink(Arrival5)
M=10^8;
s=size(Arrival5);
num_train=s(1,1);
ConLink5=sdpvar(num_train,num_train,'full');
for i=1:num_train
    ConLink5(:,i)=Arrival5(i,1)-Arrival5(:,1);%The interval between any two train services of Line5 at the starting station.
end
AllRunningtime5=Arrival5(:,end)-Arrival5(:,1);%The total running time of train services of Line5.
arf1=binvar(num_train,num_train,'full');
arf2=binvar(num_train,num_train,'full');
arf3=binvar(num_train,num_train,'full');
%%Since Shanghai Metro Line 4 is a loop line, i.e. here Line5 has the same station as its starting and ending station, it is determined that if two train services of Line5 departs from the terminal station and arrives at the terminal station within 0-30 seconds, they are assumed to be connected.
arfMIN=0;
arfMAX=30;
for j=1:num_train
    for i=1:num_train
        %%%Determine whether the two train services are connnected based on the difference between the departure interval at the starting station and the total running time of the preceding train
        xx(i,j)=AllRunningtime5(i)-ConLink5(i,j);
        arf1left(i,j)=(xx(i,j)-arfMIN)/M;
        arf1right(i,j)=1+(xx(i,j)-arfMIN)/M;
        arf2left(i,j)=(arfMAX-xx(i,j))/M;
        arf2right(i,j)=1+(arfMAX-xx(i,j))/M;
        arf3left(i,j)=(arf1left(i,j)+arf2left(i,j)-1.5)/M;
        arf3right(i,j)=1+(arf1left(i,j)+arf2left(i,j)-1.5)/M;
    end
end

