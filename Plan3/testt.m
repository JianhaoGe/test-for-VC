Qinvehicle_line5_right1=sdpvar(20,27);
Qboard_line5_left1=20*ones(20,26);
Qalight_line5_left1=5*ones(20,27);
M=99999;
ZZ11=sdpvar(20,20);
ZZ11max=M*arf3;
ZZ11min=-M*arf3;

ZZ22=sdpvar(20,20);
ZZ22max=M*(1-arf3);
ZZ22min=-M*(1-arf3);
%%%根据套跑情况，若两列车套跑，则后车在起始站的车内乘客信息继承所套跑的列车，否则为0
%%%此处ZZ1为套跑决策变量*车内乘客数量的非线性变量线性化过程
Qinvehicle_line5_right1(1,1)=0;
for k=2:27
    Qinvehicle_line5_right1(1,k)=Qinvehicle_line5_right1(1,k-1)+Qboard_line5_left1(1,k-1)-Qalight_line5_left1(1,k);
end
for i=2:20
        for j=1:i-1
            ZZ11(j,i)=ZZ22(j,i)+Qinvehicle_line5_right1(j,27);
        end
        for j=i:20
            ZZ11(j,i)=0;
            ZZ22(j,i)=0;
        end
        Qinvehicle_line5_right1(i,1)=sum(ZZ11(:,i));
    for k=2:27
        Qinvehicle_line5_right1(i,k)=Qinvehicle_line5_right1(i,k-1)+Qboard_line5_left1(i,k-1)-Qalight_line5_left1(i,k);
    end
end
CCC=[ZZ11<=ZZ11max;
    ZZ11min<=ZZ11;
    ZZ22<=ZZ22max;
    ZZ22min<=ZZ22;];
obj=-sum(sum(ZZ11));
ops = sdpsettings('solver','gurobi');
result=solvesdp(CCC,obj,ops);
