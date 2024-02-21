function [L1,L1min,L1max]=MakeLinkContraints(arf3,Arrival5)
M=10^8;
s=size(Arrival5);
num_train=s(1,1);
L1=intvar(num_train,num_train,'full');
L1min=-M*(1-arf3);
L1max=M*(1-arf3);

for j=1:num_train
    for i=1:num_train
        L1(i,j)=Arrival5(i,end)-Arrival5(j,1);
    end
end