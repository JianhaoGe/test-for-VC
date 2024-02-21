function [arf1,arf1left,arf1right,arf2,arf2left,arf2right,arf3,arf3left,arf3right,ConLink5,AllRunningtime5] = MakeLink(Arrival5)
M=10^8;
s=size(Arrival5);
num_train=s(1,1);
ConLink5=sdpvar(num_train,num_train,'full');
for i=1:num_train
    ConLink5(:,i)=Arrival5(i,1)-Arrival5(:,1);%四号线任意两车在首发站的间隔
end
AllRunningtime5=Arrival5(:,end)-Arrival5(:,1);%四号线所有车的总运行时间
arf1=binvar(num_train,num_train,'full');
arf2=binvar(num_train,num_train,'full');
arf3=binvar(num_train,num_train,'full');
%%%当四号线两列车的终点站发车及到站在0-30s内时，允许套跑
arfMIN=0;
arfMAX=30;
for j=1:num_train
    for i=1:num_train
        %%%根据在任意两列四号线在首站的发车间隔与前车的全程运行时长的差来判断是否套跑
        xx(i,j)=AllRunningtime5(i)-ConLink5(i,j);
        arf1left(i,j)=(xx(i,j)-arfMIN)/M;
        arf1right(i,j)=1+(xx(i,j)-arfMIN)/M;
        arf2left(i,j)=(arfMAX-xx(i,j))/M;
        arf2right(i,j)=1+(arfMAX-xx(i,j))/M;
        arf3left(i,j)=(arf1left(i,j)+arf2left(i,j)-1.5)/M;
        arf3right(i,j)=1+(arf1left(i,j)+arf2left(i,j)-1.5)/M;
    end
end

