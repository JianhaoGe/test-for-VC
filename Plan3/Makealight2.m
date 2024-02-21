function [Qalight_Line1_right,Qalight_Line5_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=Makealight2(Departure1,Qboard_line1_left,Rate1,Departure5,Qboard_line5_left,Rate5,arf3)
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s5=size(Departure5);
totaltrain5=s5(1,1);
totalstation5=s5(1,2);
M=99999;


Qalight_Line1_right=sdpvar(totaltrain1,totalstation1);
Qalight_Line5_right=sdpvar(totaltrain5,totalstation5);
  
Qalight_Line1_right(:,1)=0;
Qalight_Line5_right(:,1)=0;
for k=2:totalstation1
    count=1;
    for v=1:k-1
        if count==1
            Qalight_Line1_right(:,k)=Qboard_line1_left(:,v)*Rate1(v,k-1);
        else
            Qalight_Line1_right(:,k)=Qalight_Line1_right(:,k)+Qboard_line1_left(:,v)*Rate1(v,k-1);
        end
        count=count+1;
    end
end

for k=2:totalstation5
    count=1;
    for v=1:k-1
        if count==1
            Qalight_Line5_right(:,k)=Qboard_line5_left(:,v)*Rate5(v,k-1);
        else
            Qalight_Line5_right(:,k)=Qalight_Line5_right(:,k)+Qboard_line5_left(:,v)*Rate5(v,k-1);
        end
        count=count+1;
    end
end

ZZ3=sdpvar(totaltrain5,totaltrain5,totalstation5,'full');
ZZ3min=-M*repmat(arf3,[1,1,totalstation5]);
ZZ3max=M*repmat(arf3,[1,1,totalstation5]);

ZZ4=sdpvar(totaltrain5,totaltrain5,totalstation5,'full');
ZZ4min=-M*(1-repmat(arf3,[1,1,totalstation5]));
ZZ4max=M*(1-repmat(arf3,[1,1,totalstation5]));
for i=1:totaltrain5
    for ii=1:totaltrain5
        for k=2:totalstation5-2
            for v=k+1:totalstation5-1
                ZZ3(ii,i,v)=ZZ4(ii,i,v)+Qboard_line5_left(ii,v);
                Qalight_Line5_right(i,k)=Qalight_Line5_right(i,k)+ZZ3(ii,i,v)*Rate5(v,k-1);
            end
        end
    end
end
