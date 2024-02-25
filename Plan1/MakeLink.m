function [arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink2,AllRunningtime2] = MakeLink(Arrival2)
M=10^8;
s=size(Arrival2);
num_train=s(1,1);

%% ConLink2 is the interval between any two train services of Line2 at the starting station.
ConLink2=sdpvar(num_train,num_train,'full');

for i=1:num_train
    ConLink2(:,i)=Arrival2(i,1)-Arrival2(:,1);
end
AllRunningtime2=Arrival2(:,end)-Arrival2(:,1);%% The total running time of train services of Line 2.

%% arf3 is the binary variable used to describe the loop-route connnection between any two trainso of Line 2.
arf1=binvar(num_train,num_train,'full');
arf2=binvar(num_train,num_train,'full');
arf3=binvar(num_train,num_train,'full');

%%If two train services of Line 2 departs from the terminal station and arrives at the terminal station within 0-30 seconds, they are assumed to be connected.
arfMIN=0;
arfMAX=30;
for j=1:num_train
    for i=1:num_train
        %% Determine whether the two trains are connnected based on the difference between the departure interval at the starting station of one train and the total running time of the other train
        xx(i,j)=AllRunningtime2(i)-ConLink2(i,j);

        %% arf1left and arf1right are used to restrict arf1 to realize the purpose that if the interval xx is larger than arfMIN, arf1 equals 1. So do arf2 and arf3.
        arf1left(i,j)=(xx(i,j)-arfMIN)/M;
        arf1right(i,j)=1+(xx(i,j)-arfMIN)/M;
        arf2left(i,j)=(arfMAX-xx(i,j))/M;
        arf2right(i,j)=1+(arfMAX-xx(i,j))/M;
        arf3left(i,j)=(arf1left(i,j)+arf2left(i,j)-1.2)/M;
        arf3right(i,j)=1+(arf1left(i,j)+arf2left(i,j)-1.2)/M;
    end
end

