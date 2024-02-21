function [DwelltimeMAX,ConDwelltime,DwelltimeMIN]=MakeDwelltimeContraints(Arrival,Departure,MinD,MaxD)
ConDwelltime=Departure-Arrival;
s=size(Arrival);
DwelltimeMAX=(MaxD*ones(1,s(1,1)))';
DwelltimeMIN=(MinD*ones(1,s(1,1)))';