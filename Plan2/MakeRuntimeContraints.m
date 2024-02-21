function [RuntimeMAX,ConRuntime,RuntimeMIN]=MakeRuntimeContraints(Arrival,Departure,MinR,MaxR)
s=size(Arrival);
num_station=s(1,2);
ConRuntime=Arrival(:,2:num_station)-Departure(:,1:num_station-1);
s=size(ConRuntime); 
RuntimeMAX=(MaxR*ones(1,s(1,1)))';
RuntimeMIN=(MinR*ones(1,s(1,1)))';