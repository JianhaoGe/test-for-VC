function [Qalight_Line1_right,Qalight_Line2_right,ZZ3,ZZ3min,ZZ3max,ZZ4,ZZ4min,ZZ4max]=MakeAlight(Departure1,Qboard_line1_left,Rate1,Departure2,Qboard_line2_left,Rate2,arf3)
s1=size(Departure1);
totaltrain1=s1(1,1);
totalstation1=s1(1,2);
s2=size(Departure2);
totaltrain2=s2(1,1);
totalstation2=s2(1,2);
M=99999;

%% Constraint (24,45-47)

Qalight_Line1_right=sdpvar(totaltrain1,totalstation1);
Qalight_Line2_right=sdpvar(totaltrain2,totalstation2);
  
Qalight_Line1_right(:,1)=0;
Qalight_Line2_right(:,1)=0;
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

for k=2:totalstation2
    count=1;
    for v=1:k-1
        if count==1
            Qalight_Line2_right(:,k)=Qboard_line2_left(:,v)*Rate2(v,k-1);
        else
            Qalight_Line2_right(:,k)=Qalight_Line2_right(:,k)+Qboard_line2_left(:,v)*Rate2(v,k-1);
        end
        count=count+1;
    end
end

%% PAM is used to determine whether there are passengers boarding on the front train (which is connected with this train) and alighting from this train.
%% If arf(ii,i)==1; ZZ3(ii,i,v)=Qboard_line2_left(ii,v).

ZZ3=sdpvar(totaltrain2,totaltrain2,totalstation2,'full');
ZZ3min=-M*repmat(arf3,[1,1,totalstation2]);
ZZ3max=M*repmat(arf3,[1,1,totalstation2]);

ZZ4=sdpvar(totaltrain2,totaltrain2,totalstation2,'full');
ZZ4min=-M*(1-repmat(arf3,[1,1,totalstation2]));
ZZ4max=M*(1-repmat(arf3,[1,1,totalstation2]));
for i=1:totaltrain2
    for ii=1:totaltrain2
        for k=2:totalstation2-2
            for v=k+1:totalstation2-1
                %% Note: code omitted.
                Qalight_Line2_right(i,k)=Qalight_Line2_right(i,k)+ZZ3(ii,i,v)*Rate2(v,k-1);
            end
        end
    end
end
