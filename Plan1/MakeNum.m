function [aamin,aamax,aa,Num1,Num3,Num5,Numall,AllDeparture]=MakeNum(Departure1,Departure3,Departure5,Line1,Line3,Line5,Ss)
s1=size(Departure1);
Totaltrain1=s1(1,1);
Totalstation1=s1(1,2);
s3=size(Departure3);
Totaltrain3=s3(1,1);
Totalstation3=s3(1,2);
s5=size(Departure5);
Totaltrain5=s5(1,1);
Totalstation5=s5(1,2);

M=10^8;
Sall=length(Ss);
Totaltrain=Totaltrain1+Totaltrain3+Totaltrain5;

AllDeparture=sdpvar(Totaltrain,Sall);
Num1=intvar(Totaltrain1,Totalstation1-1);
Num3=intvar(Totaltrain3,Totalstation3-1);
Num5=intvar(Totaltrain5,Totalstation5-1);

aa=binvar(Totaltrain,Totaltrain,Sall,'full');

for i=1:Sall
    for j=1:Totaltrain1
       j1=find(Line1.From==Ss(i));
       if isempty(j1)==0
           AllDeparture(j,i)=Departure1(j,j1);
       end
    end
    for j=1:Totaltrain3
       j3=find(Line3.From==Ss(i));
       if isempty(j3)==0
           AllDeparture(j+Totaltrain1,i)=Departure3(j,j3);
       end
    end
    for j=1:Totaltrain5
       j5=find(Line5.From==Ss(i));
       if isempty(j5)==0
           AllDeparture(j+Totaltrain1+Totaltrain3,i)=Departure5(j,j5);
       end
    end
end

for i=1:Totaltrain
    for j=1:Totaltrain
        for k=1:Sall
            if i==j
                aamin(i,j,k)=0;
                aamax(i,j,k)=0;
            else
                aamin(i,j,k)=(AllDeparture(i,k)-AllDeparture(j,k))/M;
                aamax(i,j,k)=(AllDeparture(i,k)-AllDeparture(j,k))/M+1;
            end
        end
    end
end

Numall=squeeze(sum(aa,2))+1;

for i=1:Totaltrain1
    for j=1:Totalstation1-1
        Num1(i,j)=Numall(i,(Ss==Line1.From(j)));
    end
end
for i=1:Totaltrain3
    for j=1:Totalstation3-1
        Num3(i,j)=Numall(i+Totaltrain1,(Ss==Line3.From(j)));
    end
end
for i=1:Totaltrain5
    for j=1:Totalstation5-1
        Num5(i,j)=Numall(i+Totaltrain1+Totaltrain3,(Ss==Line5.From(j)));
    end
end

