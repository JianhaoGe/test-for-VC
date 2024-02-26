%% This program is used to solve the model of Plan I, including 2 route train lines.
%% Line 1 presents the long-route train line of Shanghai Metro Line 3;
%% Line 2 presents the loop-route train line of Shanghai Metro Line 4.

%% Input （The input is the same as Main.m, it can be directly run after Main.m running to show the effect of the solution.)

%% Value:
%% TrainCapacity -- The standard capacity of trains;
%% fullloadrate  -- The maximum allowable full load rate of a train;
%% M             -- A sufficiently large constant number;
%% MinD          -- Minimum dwelltime time coefficient;
%% MaxD          -- Maximum dwelltime time coefficient;
%% MinH          -- Minimum headway time of successive trains;
%% MaxH          -- Maximum headway time of successive trains;
%% MinVC         -- Minimum headway time of successive trains of different lines when they are virtual coupled;
%% MaxVC         -- Maximum headway time of successive trains of different lines when they are virtual coupled;
%% Totaltrain1   -- The total number of Line 1; 
%% Totalstation1 -- The total station number of Line 1;
%% Totaltrain2   -- The total number of Line 2;
%% Totalstation2 -- The total station number of Line 2;
%% Sharestation  -- The number of shared stations;
%% Starttime     -- The starting point of research time period;
%% Endtime       -- The ending point of research time period;
%% MinLink       -- The minimum total times of connected train service pairs of Line 2;
%% STime         -- The starting point of passenger OD data;
%% ETime         -- The ending point of passenger OD data;
%% Timestamp     -- The length of a time inteval (The granularity of passenger OD data);
%% Fcommonstop1  -- The sequence of the first station in the collinear corridor for Line 1;
%% Fcommonstop2  -- The sequence of the first station in the collinear corridor for Line 2;
%% Note: Here, Totaltrain1 = Totaltrain2.

%% Matrix:
%% MinR1(Totalstation1-1,1)      -- The minimum running time of each section of Line 1;
%% MaxR1(Totalstation1-1,1)      -- The maximum running time of each section of Line 1;
%% Dwelltime1(Totalstation1,1)   -- The standard dwelltime of each station of Line 1;
%% MinR2(Totalstation2-1,1)      -- The minimum running time of each section of Line 2;
%% MaxR2(Totalstation2-1,1)      -- The maximum running time of each section of Line 2;
%% Dwelltime2(Totalstation2,1)   -- The standard dwelltime of each station of Line 2;
%% Line1(Totalstation1,1)        -- The station name of Line 1;
%% Line2(Totalstation2,1)        -- The station name of Line 2;
%% CommonStopSet(Sharestation,1) -- The station name of shared stations.



%% load("result.mat"); %% A sample result is provided here.


%% Draw the basemap
for i=1:50
    x=[];
    y=[];
    x(1)=7*3600;
    y(1)=i*10;
    x(2)=10*3600;
    y(2)=i*10;
    if i~=2 && i~=32
        plot(x,y,'--','Color',[0.7451,0.7451,0.7451]);
        hold on
    end
end
for i=1:18
    x=[];
    y=[];
    x(1)=i*600+7*3600;
    y(1)=0;
    x(2)=i*600+7*3600;
    y(2)=510;
    plot(x,y,'--','Color',[0.7451,0.7451,0.7451]);
    hold on
end
set(gca,'ytick',[0,10,30:10:310,330:10:500]);
set(gca,'yticklabel',[1:49]);
set(gca,'xtick',[Starttime:1800:Endtime]);
set(gca,'xticklabel',["7:00","7:10","7:20","7:30","7:40","7:50","8:00","8:10","8:20","8:30","8:40","8:50","9:00","9:10","9:20","9:30","9:40","9:50","10:00"]);
set(gca,'FontSize',8);

%% Draw the loop-line connection relationship between train services of Line 2 with black dashed line
for i=1:6
    x=[];
    y=[];
    x(1)=double(Arrival2(i,end));
    y(1)=0;
    x(2)=double(Arrival2(14+i,1));
    y(2)=500;
    plot(x,y,'--','Color',[0 0 0]);
    hold on
end

%% Draw the virtual coupling relationship between virtual coupling trains with yellow blanks
for i=1:Totaltrain1
    a=160;
    for j=16:23
        if double(VCor15(i,1))==0
            x=[];
            y=[];
            x(1)=double(Departure1(i,j))-50;
            y(1)=a;
            x(2)=double(Departure1(i,j))+80;
            y(2)=a;
            x(3)=double(Arrival1(i,j+1))+80;
            y(3)=a-10;
            x(4)=double(Arrival1(i,j+1))-50;
            y(4)=a-10;
            x(5)=x(1);
            y(5)=y(1);
            A=fill(x,y,'y');
            set(A,{'LineStyle'},{'none'})
            x=[];
            y=[];
            x(1)=double(Arrival1(i,j));
            y(1)=a-2;
            x(2)=double(Arrival1(i,j));
            y(2)=a+2;
            x(3)=double(Departure1(i,j));
            y(3)=a+2;
            x(4)=double(Departure1(i,j));
            y(4)=a-2;
            x(5)=x(1);
            y(5)=y(1);
            A=fill(x,y,'y');
            set(A,{'LineStyle'},{'none'})
        end
        if double(VCor15(i,2))==0
            x=[];
            y=[];
            x(1)=double(Departure1(i,j))-80;
            y(1)=a;
            x(2)=double(Departure1(i,j))+50;
            y(2)=a;
            x(3)=double(Arrival1(i,j+1))+50;
            y(3)=a-10;
            x(4)=double(Arrival1(i,j+1))-80;
            y(4)=a-10;
            x(5)=x(1);
            y(5)=y(1);
            A=fill(x,y,'y');
            set(A,{'LineStyle'},{'none'})
            x=[];
            y=[];
            x(1)=double(Arrival1(i,j));
            y(1)=a-2;
            x(2)=double(Arrival1(i,j));
            y(2)=a+2;
            x(3)=double(Departure1(i,j));
            y(3)=a+2;
            x(4)=double(Departure1(i,j));
            y(4)=a-2;
            x(5)=x(1);
            y(5)=y(1);
            A=fill(x,y,'y');
            set(A,{'LineStyle'},{'none'})
        end
        a=a-10;
    end
end


%% Draw the train running paths with full load rate markings and stranded passenger markings
for i=1:Totaltrain1
    a=310;
    for j=1:28
        x=[];
        y=[];
        x(1)=double(Arrival1(i,j));
        y(1)=a;
        x(2)=double(Departure1(i,j));
        y(2)=a;
        if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,'-','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure1(i,j));
        y(1)=a;
        x(2)=double(Arrival1(i,j+1));
        y(2)=a-10;
        if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,'-','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure1(i,j));
        y(1)=a;
        x(2)=double(Departure1(i,j))+100;
        y(2)=a;
        x(3)=double(Departure1(i,j))+100;
        y(3)=a-double(Qstranded_line1_left(i,j))/500;
        x(4)=double(Departure1(i,j));
        y(4)=a-double(Qstranded_line1_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line1_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line1_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line1_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line1_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line1_left(i,j))<=4000 %stranded passenger 2000~4000
                             fill(x,y,'m');
                             hold on
                         else 
                             fill(x,y,'r'); %stranded passenger over 4000
                             hold on
                         end
                    end
                end
            end
        end
        a=a-10;
    end
end


for i=1:Totaltrain2
    c=500;
    for j=1:17
        x=[];
        y=[];
        x(1)=double(Arrival2(i,j));
        y(1)=c;
        x(2)=double(Departure2(i,j));
        y(2)=c;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j));
        y(1)=c;
        x(2)=double(Arrival2(i,j+1));
        y(2)=c-10;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j))+100;
        y(1)=c;
        x(2)=double(Departure2(i,j))+200;
        y(2)=c;
        x(3)=double(Departure2(i,j))+200;
        y(3)=c-double(Qstranded_line2_left(i,j))/500;
        x(4)=double(Departure2(i,j))+100;
        y(4)=c-double(Qstranded_line2_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line2_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line2_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line2_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line2_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line2_left(i,j))<=4000 %stranded passenger 2000~4000
                             fill(x,y,'m');
                             hold on
                         else 
                             fill(x,y,'r'); %stranded passenger over 4000
                             hold on
                         end
                    end
                end
            end
        end
        c=c-10;
    end
    c=160;
    for j=18:25
        x=[];
        y=[];
        x(1)=double(Arrival2(i,j));
        y(1)=c;
        x(2)=double(Departure2(i,j));
        y(2)=c;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j));
        y(1)=c;
        x(2)=double(Arrival2(i,j+1));
        y(2)=c-10;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j))+100;
        y(1)=c;
        x(2)=double(Departure2(i,j))+200;
        y(2)=c;
        x(3)=double(Departure2(i,j))+200;
        y(3)=c-double(Qstranded_line2_left(i,j))/500;
        x(4)=double(Departure2(i,j))+100;
        y(4)=c-double(Qstranded_line2_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line2_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line2_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line2_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line2_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line2_left(i,j))<=4000 %stranded passenger 2000~4000
                             fill(x,y,'m');
                             hold on
                         else 
                             fill(x,y,'r'); %stranded passenger over 4000
                             hold on
                         end
                    end
                end
            end
        end
        c=c-10;
    end
    j=j+1;
        x=[];
        y=[];
        x(1)=double(Arrival2(i,j));
        y(1)=10;
        x(2)=double(Departure2(i,j));
        y(2)=10;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j));
        y(1)=10;
        x(2)=double(Arrival2(i,j+1));
        y(2)=0;
        if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line2_left(i,j))+double(Qboard_line2_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0]; %full load rate over 100%
                            end
                        end
                    end
                end
            end
        end
        plot(x,y,':','Color',color,'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure2(i,j))+100;
        y(1)=10;
        x(2)=double(Departure2(i,j))+200;
        y(2)=10;
        x(3)=double(Departure2(i,j))+200;
        y(3)=10-double(Qstranded_line2_left(i,j))/500;
        x(4)=double(Departure2(i,j))+100;
        y(4)=10-double(Qstranded_line2_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line2_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line2_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line2_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line2_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line2_left(i,j))<=4000 %stranded passenger 2000~4000
                             fill(x,y,'m');
                             hold on
                         else 
                             fill(x,y,'r');
                             hold on
                         end
                    end
                end
            end
        end
end

%% Legend settings
axis([7*3600 10*3600 0 500]);
Ct(1)=plot(NaN,NaN,'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
Ct(2)=plot(NaN,NaN,'Color',[0.67843,1,0.18431],'LineWidth',1.5);
Ct(3)=plot(NaN,NaN,'Color',[1,0.84314,0],'LineWidth',1.5);
Ct(4)=plot(NaN,NaN,'Color',[0.95686,0.65314,0.37647],'LineWidth',1.5);
Ct(5)=plot(NaN,NaN,'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
Ct(6)=plot(NaN,NaN,'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
Ct(7)=plot(NaN,NaN,'Color',[1,0,0],'LineWidth',1.5);
St(1)=fill(NaN,NaN,'g');
St(2)=fill(NaN,NaN,'c');
St(3)=fill(NaN,NaN,'y');
St(4)=fill(NaN,NaN,'b');
St(5)=fill(NaN,NaN,'m');
St(6)=fill(NaN,NaN,'r');
legend(Ct,'(0,50%]','(50%,60%]','(60%,70%]','(70%,80%]','(80%,90%]','(90%,100%]','>100%');
lgd=legend;
lgd.Title.String='Full Load Rate';
ah=axes('position',get(gca,'position'),...
    'visible','off');
legend(ah,St,'(0,300]','(300,500]','(500,1000]','(1000,2000]','(2000,4000]','>4000','Location','NorthEastOutside');
lgd2=legend;
lgd2.Title.String='Stranded';
xlabel('Time');ylabel('Station');
