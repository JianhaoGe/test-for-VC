# test-for-VC
This explicit Github repository stores the detailed instructions, desensitized data and part of computer programming in Matlab. The described method is used to reproduce the results shown in the paper named "Transport Capacity Analysis for Sharing-Corridor Metro Lines under Virtual Coupling". 
Due to the confidentiality agreements, we have desensitized the data. Readers can still obtain optimized schedules based on our model with the desensitized data input and obtain approximate results. Besides, in order to assist readers in reproducing our results, we have also uploaded the code for calculating capacity utilization (in Fig.7). Readers can input their optimized timetable to calculate the capacity utilization under virtual coupling conditions using this code.
We are willing to see further development from our research results.

# Instruction of SampleInput.mat
TrainCapacity -- The standard capacity of trains;
fullloadrate  -- The maximum allowable full load rate of a train;
M             -- A sufficiently large constant number;
MinD          -- Minimum dwelltime time coefficient;
MaxD          -- Maximum dwelltime time coefficient;
MinH          -- Minimum headway time of successive trains;
MaxH          -- Maximum headway time of successive trains;
MinVC         -- Minimum headway time of successive trains of different lines when they are virtual coupled;
MaxVC         -- Maximum headway time of successive trains of different lines when they are virtual coupled;
Totaltrain1   -- The total number of Line 1; 
Totalstation1 -- The total station number of Line 1;
Totaltrain2   -- The total number of Line 2;
Totalstation2 -- The total station number of Line 2; (Note: In the sample result, Totaltrain1 = Totaltrain2.)
Sharestation  -- The number of shared stations;
Starttime     -- The starting point of research time period;
Endtime       -- The ending point of research time period;
MinLink       -- The minimum total times of connected train service pairs of Line 2;
STime         -- The starting point of passenger OD data;
ETime         -- The ending point of passenger OD data;
Timestamp     -- The length of a time inteval (The granularity of passenger OD data);
Fcommonstop1  -- The sequence of the first station in the collinear corridor for Line 1;
Fcommonstop2  -- The sequence of the first station in the collinear corridor for Line 2;
MinR1(Totalstation1-1,1)      -- The minimum running time of each section of Line 1;
MaxR1(Totalstation1-1,1)      -- The maximum running time of each section of Line 1;
Dwelltime1(Totalstation1,1)   -- The standard dwelltime of each station of Line 1;
MinR2(Totalstation2-1,1)      -- The minimum running time of each section of Line 2;
MaxR2(Totalstation2-1,1)      -- The maximum running time of each section of Line 2;
Dwelltime2(Totalstation2,1)   -- The standard dwelltime of each station of Line 2;
Line1(Totalstation1,1)        -- The station name of Line 1;
Line2(Totalstation2,1)        -- The station name of Line 2;
CommonStopSet(Sharestation,1) -- The station name of shared stations.

# Instruction of PassengerDown.mat
ArrivalRate(Totalstation-1,(Endtime-Starttime)/Timestamp): the arrival rate of each specific station (people/second)
ArrivalRate1(Totalstation1-1,(Endtime-Starttime)/Timestamp): those passengers who can only take Line 1.
ArrivalRate2(Totalstation2-1,(Endtime-Starttime)/Timestamp): those passengers who can only take Line 2.
ArrivalRateShare(Sharestation-1,(Endtime-Starttime)/Timestamp): those passengers who can both take Line 1 and Line 2.
AlightRate(Totalstation-1,Totalstation-1,(Endtime-Starttime)/Timestamp): the arrival rate of each specific OD pair (people/second)
AlightRate1(Totalstation1-1,Totalstation1-1,(Endtime-Starttime)/Timestamp): those passengers who can only take Line 1.
AlightRate2(Totalstation2-1,Totalstation2-1,(Endtime-Starttime)/Timestamp): those passengers who can only take Line 2.
AlightRateShare(Sharestation-1,Sharestation-1,(Endtime-Starttime)/Timestamp): those passengers who can both take Line 1 and Line 2.
Rate(Totalstation-1,Totalstation-1): the average proportion of passengers destined for station D among all the passengers boarding at station O during the whole research period.
Rate1(Totalstation1-1,Totalstation1-1): the average proportion for Line 1.
Rate2(Totalstation1-1,Totalstation1-1): the average proportion for Line 2.
Note: For those OD pairs, which station O and station D are all in the collinear corridor, Rate1 = Rate2.

# Instruction of result.mat
arf3(Totaltrain2,Totaltrain2): the connection relationship of trains of Line 2 in Constraint 6.
Arrival1(Totaltrain1, Totalstation1): the arrival time at each station of trains of Line 1.
Arrival2(Totaltrain2, Totalstation2): the arrival time at each station of trains of Line 2.
Departure1(Totaltrain1, Totalstation1): the departure time at each station of trains of Line 1.
Departure2(Totaltrain2, Totalstation2): the departure time at each station of trains of Line 2.
Cremain_line1_left(Totaltrain1, Totalstation1): the remaining capacity of trains of Line 1 at each station.
Cremain_line2_left(Totaltrain2, Totalstation2): the remaining capacity of trains of Line 2 at each station.
Qalight_line1_left(Totaltrain1, Totalstation1): the number of passengers alighting from trains of Line 1 at each station.
Qalight_line2_left(Totaltrain2, Totalstation2): the number of passengers alighting from trains of Line 2 at each station.
QArrival_line1_left(Totaltrain1, Totalstation1-1): the number of passengers arriving at stations and want to take trains of Line 1.
QArrival_line2_left(Totaltrain2, Totalstation2-1): the number of passengers arriving at stations and want to take trains of Line 2.
Qboard_line1_left(Totaltrain1, Totalstation1-1): the number of passengers board the trains of Line 1 at each station.
Qboard_line2_left(Totaltrain2, Totalstation2-1): the number of passengers board the trains of Line 2 at each station.
Qinvehicle_line1_left(Totaltrain1, Totalstation1): the number of passengers in the vehicle of trains of Line 1 at each station after passengers alighting and before passengers boarding.
Qinvehicle_line2_left(Totaltrain2, Totalstation2): the number of passengers in the vehicle of trains of Line 2 at each station after passengers alighting and before passengers boarding.
Qstranded_line1_left(Totaltrain1, Totalstation1): the number of passengers stranded from trains of Line 1 at each station.
Qstranded_line2_left(Totaltrain2, Totalstation2): the number of passengers stranded from trains of Line 2 at each station.
Qwait_line1_left(Totaltrain1, Totalstation1-1): the number of passengers who wait for trains of Line 1 at each station.
Qwait_line2_left(Totaltrain2, Totalstation2-1): the number of passengers who wait for trains of Line 2 at each station.
VCor12(Totaltrain1, 2): the binary variables show whether the train of Line 1 is virtually coupled with its front train (a train of Line2) or its rear train (another train of Line2).
