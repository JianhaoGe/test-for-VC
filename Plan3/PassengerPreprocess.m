% Passenger=table;
% Passenger.ID=zeros(300000,1);
% Passenger.From=zeros(300000,1);
% Passenger.From=string(Passenger.From);
% Passenger.To=zeros(300000,1);
% Passenger.To=string(Passenger.To);
% Passenger.Otime=zeros(300000,1);
% Passenger.Dtime=zeros(300000,1);
% Passenger.Direction=zeros(300000,1);
n=0;
Passenger.ID=[];
Passenger.From=[];
Passenger.To=[];
Passenger.Otime=[];
Passenger.Dtime=[];
Passenger.Direction=[];
for i=1:488208
    if All03(i,7)>7*3600&&All03(i,7)<11*3600
        n=n+1;
        Passenger.ID(n,1)=n;
%         k=find(ID.StationID==All03(i,1));
%         Passenger.From(n)=ID.Station(k);
%         k=find(ID.StationID==All03(i,3));
%         Passenger.To(n)=ID.Station(k);
        Passenger.From(n,1)=All03(i,1);
        Passenger.To(n,1)=All03(i,3);
        Passenger.Otime(n,1)=All03(i,7);
        Passenger.Dtime(n,1)=All03(i,8);
        Passenger.Direction(n,1)=All03(i,6);
    end
end
for i=1:794491
    if All04(i,7)>7*3600&&All04(i,7)<11*3600
        n=n+1;
        Passenger.ID(n,1)=n;
%         k=find(ID.StationID==All04(i,1));
%         Passenger.From(n)=ID.Station(k);
%         k=find(ID.StationID==All04(i,3));
%         Passenger.To(n)=ID.Station(k);
        Passenger.From(n,1)=All04(i,1);
        Passenger.To(n,1)=All04(i,3);
        Passenger.Otime(n,1)=All04(i,7);
        Passenger.Dtime(n,1)=All04(i,8);
        Passenger.Direction(n,1)=All04(i,6)+1;
    end
end
for i=1:length(Passenger.Direction)
    if Passenger.Direction(i)==3
        Passenger.Direction(i)=1;
    end
end
Passenger.From=string(Passenger.From);
Passenger.To=string(Passenger.To);
for i=1:length(Passenger.Direction)
    for j=1:56
        if double(Passenger.From(i))==ID.VarName1(j)
            Passenger.From(i)=ID.VarName3(j);
        end
        if double(Passenger.To(i))==ID.VarName1(j)
            Passenger.To(i)=ID.VarName3(j);
        end
    end
end