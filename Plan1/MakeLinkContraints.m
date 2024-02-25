function [L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival2)
M=10^8;
s=size(Arrival2);
num_train=s(1,1);
L1=intvar(num_train,num_train,'full');

%% According to the function of MakeLink, if train i and j of Line 2 are set to be connected, they have the same arrival and departure time at the terminal station (the ending station of the front train and the starting station of the rear train).
L1min=-M*(1-arf3);
L1max=M*(1-arf3);

for j=1:num_train
    for i=1:num_train
        L1(i,j)=Arrival2(i,end)-Arrival2(j,1);
    end
end
