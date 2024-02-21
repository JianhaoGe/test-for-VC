load('Passenger2');
P=Passenger(Passenger.Direction==1,:);
load('Ã◊≈‹6£¨÷Õ¡Ù◊Ó–°.mat');
load('Runningtime');
Line1=Runningtime(Runningtime.Planning==1,:);
Station1=[Line1.From;Line1.To(end)];
Line3=Runningtime(Runningtime.Planning==3,:);
Station3=[Line3.From;Line3.To(end)];
Line5=Runningtime(Runningtime.Planning==5,:);
Station5=[Line5.From;Line5.To(end)];
Event=[Departure1(:);Departure3(:);Departure5(:)];
Event=sort(Event);
for i=1:length(Event)
    [m,n]=find(Departure1==Event(i,1));
    if isempty([m,n])==0
        for j=1:length(Station1)
            if m==1
                od=P(P.Otime<=Event(i,1) & P.Otime>Event(i,1)-180 & P.From==Station1(n) & strcmp(Station1(j),P.To),:);
            else
                od=P(P.Otime<=Event(i,1) & P.Otime>Departure & P.From==Station1(n) & strcmp(Station1(j),P.To),:);
            
            
    else
        [m,n]=find(Departure3==Event(i,1));
    end
    if isempty([m,n])
        [m,n]=find(Departure5==Event(i,1));
    end
        
end

