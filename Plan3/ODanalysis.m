load('Runningtime.mat');
Stime=7*3600;
Etime=11*3600;
Timestamp=300;
Line1=Runningtime(Runningtime.Planning==1,:);
Line3=Runningtime(Runningtime.Planning==3,:);
Line5=Runningtime(Runningtime.Planning==5,:);
CommonStopSet1=Line1.From(9:28);
CommonStopSet2=Line1.From(16:23);
load('Passenger2.mat');
P=Passenger(Passenger.Direction==1,:);
ArrivalRate1=zeros(length(Line1.From),(Etime-Stime)/Timestamp);
ArrivalRate5=zeros(length(Line5.From),(Etime-Stime)/Timestamp);
ArrivalRateShare=zeros(length(CommonStopSet2),(Etime-Stime)/Timestamp);
AlightRate1=zeros(length(Line1.From),length(Line1.To),(Etime-Stime)/Timestamp);
AlightRate5=zeros(length(Line5.From),length(Line5.To),(Etime-Stime)/Timestamp);
AlightRateShare=zeros(length(CommonStopSet2),length(CommonStopSet2),(Etime-Stime)/Timestamp);

for i=1:(Etime-Stime)/Timestamp
    t=(i-1)*Timestamp+Stime;
    for s=1:length(Line1.From)
        for k=1:length(Line1.To)
            od=P(P.Otime>=t & P.Otime<=t+Timestamp-1 & strcmp(Line1.From(s,1),P.From) & strcmp(Line1.To(k,1),P.To),: );
            p.number=length(od.Otime);
            AlightRate1(s,k,i)=AlightRate1(s,k,i)+p.number;
            ArrivalRate1(s,i)=ArrivalRate1(s,i)+p.number;
        end  
    end    
end
p.number=[];    
od=[];

ArrivalRate3=ArrivalRate1(9:end,:);
AlightRate3=AlightRate1(9:end,9:end,:);

for i=1:(Etime-Stime)/Timestamp
    t=(i-1)*Timestamp+Stime;
    for s=1:length(Line5.From)
        for k=1:length(Line5.From)
            od=P(P.Otime>=t & P.Otime<=t+Timestamp-1 & strcmp(Line5.From(s,1),P.From) & strcmp(Line5.To(k,1),P.To),: );
            p.number=length(od.Otime);
            AlightRate5(s,k,i)=AlightRate5(s,k,i)+p.number;
            ArrivalRate5(s,i)=ArrivalRate5(s,i)+p.number;
        end 
    end    
end

p.number=[];
od=[];

for i=1:(Etime-Stime)/Timestamp
    t=(i-1)*Timestamp+Stime;
    for s=1:length(CommonStopSet2)
        for k=1:length(CommonStopSet2)
            od=P(P.Otime>=t & P.Otime<=t+Timestamp-1 & strcmp(Line5.From(s+17,1),P.From) & strcmp(Line5.To(k+17,1),P.To) & strcmp(Line1.To(k+15,1),P.To) & strcmp(Line1.From(s+15,1),P.From),: );
            p.number=length(od.Otime);
            AlightRateShare(s,k,i)=AlightRateShare(s,k,i)+p.number;
            ArrivalRateShare(s,i)=ArrivalRateShare(s,i)+p.number;
        end 
    end    
end

ArrivalRate1(16:23,:)=ArrivalRate1(16:23,:)-ArrivalRateShare;
ArrivalRate3(8:15,:)=ArrivalRate3(8:15,:)-ArrivalRateShare;
ArrivalRate5(18:25,:)=ArrivalRate5(18:25,:)-ArrivalRateShare;
AlightRate1(16:23,16:23,:)=AlightRate1(16:23,16:23,:)-AlightRateShare;
AlightRate3(8:15,8:15,:)=AlightRate3(8:15,8:15,:)-AlightRateShare;
AlightRate5(18:25,18:25,:)=AlightRate5(18:25,18:25,:)-AlightRateShare;

ArrivalRate1=ArrivalRate1/Timestamp;
AlightRate1=AlightRate1/Timestamp;
ArrivalRate3=ArrivalRate3/Timestamp;
AlightRate3=AlightRate3/Timestamp;
AlightRate5=AlightRate5/Timestamp;
ArrivalRate5=ArrivalRate5/Timestamp;
ArrivalRateShare=ArrivalRateShare/Timestamp;
AlightRateShare=AlightRateShare/Timestamp;

save PassengerDown2 ArrivalRate1 ArrivalRate3 ArrivalRate5 AlightRate1 AlightRate3 AlightRate5 ArrivalRateShare AlightRateShare


Demand1=sum(AlightRate1,3);
Demand3=sum(AlightRate3,3);
Demand5=sum(AlightRate5,3);
PS1=sum(ArrivalRate1,2);
PS3=sum(ArrivalRate3,2);
PS5=sum(ArrivalRate5,2);

for O=1:length(Line1.From)
    for D=1:length(Line1.To)
        Rate1(O,D)=Demand1(O,D)/PS1(O,1);
    end
end
idx=find(isnan(Rate1)); % find all NaN values
 Rate1(idx)=0; % set 1 to these indexes
 
 for O=1:length(Line3.From)
    for D=1:length(Line3.To)
        Rate3(O,D)=Demand3(O,D)/PS3(O,1);
    end
end
idx=find(isnan(Rate3)); % find all NaN values
 Rate3(idx)=0; % set 1 to these indexes
 
 for O=1:length(Line5.From)
    for D=1:length(Line5.To)
        Rate5(O,D)=Demand5(O,D)/PS5(O,1);
    end
end
idx=find(isnan(Rate5)); % find all NaN values
 Rate5(idx)=0; % set 1 to these indexes
 
 save PassengerDown4 Rate1 Rate3 Rate5

Alightpercent1=zeros(length(Line1.From),length(Line1.To),(Etime-Stime)/Timestamp);
Alightpercent5=zeros(length(Line5.From),length(Line5.To),(Etime-Stime)/Timestamp);

ArrivalRate1(16:23,:)=ArrivalRate1(16:23,:)+0.5*ArrivalRateShare;
ArrivalRate3(8:15,:)=ArrivalRate3(8:15,:)+0.5*ArrivalRateShare;
ArrivalRate5(18:25,:)=ArrivalRate5(18:25,:)+0.5*ArrivalRateShare;
AlightRate1(16:23,16:23,:)=AlightRate1(16:23,16:23,:)+0.5*AlightRateShare;
AlightRate3(8:15,8:15,:)=AlightRate3(8:15,8:15,:)+0.5*AlightRateShare;
AlightRate5(18:25,18:25,:)=AlightRate5(18:25,18:25,:)+0.5*AlightRateShare;

for i=1:(Etime-Stime)/Timestamp
    for s=1:length(Line1.From)
        for k=1:length(Line1.To)
            if ArrivalRate1(s,i)~=0
                Alightpercent1(s,k,i)=AlightRate1(s,k,i)/ArrivalRate1(s,i);
            end
        end  
    end    
end

Alightpercent3=Alightpercent1(9:end,9:end,:);

for i=1:(Etime-Stime)/Timestamp
    for s=1:length(Line5.From)
        for k=1:length(Line5.To)
            if ArrivalRate5(s,i)~=0
                Alightpercent5(s,k,i)=AlightRate5(s,k,i)/ArrivalRate5(s,i);
            end
        end  
    end    
end


save PassengerDown3 Alightpercent1 Alightpercent3 Alightpercent5
