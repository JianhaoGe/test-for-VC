%% Initialization.
%%In this code, Line1 presents the long-route train line of Shanghai Metro Line3;
%%Line 5 presents the loop-route train line of Shanghai Metro Line4;
TrainCapacity=340*6;
fullloadrate=1.2;%Maximum allowable full load rate is 120%
Cmax=fullloadrate*TrainCapacity;%Maximum train capacity

M=99999;


load('Runningtime.mat');%Loading runningtime data
load('Dwelltime.mat');%Loading dwelltime data
MinD=1;%Minimum dwelltime time coefficient
MaxD=1.2;%Maximum dwelltime time coefficient
MinH=120;%Minimum headway time of successive trains (seconds)
MaxH=300;%Maximum headway time of successive trains (seconds)

MinVC=30;%Minimum headway time of successive trains of different lines when they are virtual coupled (seconds)

%Initialization of Line1: long-route train line of Shanghai Metro Line3;
Line1=Runningtime(Runningtime.Planning==1,:);%Select stations of Line1
Totaltrain1=20;%Define the total train number of Line1
Totalstation1=length(Line1.ID)+1;%Calculate the total station number of Line1
MinR1=fix(Line1.Time)*60+mod(Line1.Time*100,100);%Calculate the minimum running time of each section of Line1 (seconds)
MaxR1=MinR1*1.2;%Calculate the maximum running time of each section of Line1 (seconds)
Dwelltime1=Dwelltime(Dwelltime.Planning==1,:);%Select train dwelltime of Line1
MinD1=Dwelltime1.Time*100*MinD;%Calculate the minimum dwelltime at each station of Line 1
MaxD1=MinD1*MaxD;%Calculate the maximum dwelltime at each station of Line 1

%Initialization of Line5: loop-route train line of Shanghai Metro Line4;
Line5=Runningtime(Runningtime.Planning==5,:);%Select stations of Line5
Totaltrain5=20;%Define the total train number of Line5
Totalstation5=length(Line5.ID)+1;%Calculate the total station number of Line5
MinR5=fix(Line5.Time)*60+mod(Line5.Time*100,100);%Calculate the minimum running time of each section of Line5 (seconds)
MaxR5=MinR5*1.2;%Calculate the maximum running time of each section of Line5 (seconds)
Dwelltime5=Dwelltime(Dwelltime.Planning==5,:);%Select train dwelltime of Line5
MinD5=Dwelltime5.Time*100*MinD;%Calculate the minimum dwelltime at each station of Line 5
MaxD5=MinD5*MaxD;%Calculate the maximum dwelltime at each station of Line 5

%%Determine the collinear stations of Line1 and Line5
CommonStopSet2=Line1.From(16:24);

%load("result.mat");


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
% set(gca,'ytick',[0,10,30:10:310,330:10:500]);
% set(gca,'yticklabel',["Yishan Road","Hongqiao Road","Shanghai South Railway Station","Shilong Road","Longcao Road","Caoxi Road","Yishan Road","Hongqiao Road","West Yan'an Road","Zhongshan Park","Jinshajiang Road","Caoyang Road","Zhenping Road","Zhongtan Road","Shanghai Railway Station","Baoshan Road","Dongbaoxing Road","Hongkou Football Stadium","Chifeng Road","Dabaishu","Jiangwan Town","West Yingao Road","South Changjiang Road","Songfa Road","Zhanghuabang","Songbin Road","Shuichan Road","Baoyang Road","Youyi Road","Tieli Road","North Jiangyang Road","Baoshan Road","Hailun Road","Linping Road","Dalian Road","Yangshupu Road","Pudong Avenue","Century Avenue","Pudian Road","Lancun Road","Tangqiao","Nanpu Bridge","South Xizang Road","Luban Road","Damuqiao Road","Dong'an Road","Shanghai Gymnasium","Shanghai Stadium","Yishan Road"]);
% set(gca,'xtick',[7*3600:600:10*3600]);
% set(gca,'xticklabel',["7:00","7:10","7:20","7:30","7:40","7:50","8:00","8:10","8:20","8:30","8:40","8:50","9:00","9:10","9:20","9:30","9:40","9:50","10:00"]);
% set(gca,'FontSize',6);
set(gca,'ytick',[0,10,30,80,160,230,310,330,500]);
set(gca,'yticklabel',["YSR","HQR","SHSRS","HQR","BSR","SCJR","NJYR","BSR","YSR"]);
set(gca,'xtick',[7*3600:1800:10*3600]);
set(gca,'xticklabel',["7:00","7:30","8:00","8:30","9:00","9:30","10:00"]);
set(gca,'FontSize',8);

%% Draw the loop-line connection relationship between train services of Shanghai Metro Line4 with black dashed line
for i=1:6
    x=[];
    y=[];
    x(1)=double(Arrival5(i,end));
    y(1)=0;
    x(2)=double(Arrival5(14+i,1));
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


for i=1:Totaltrain5
    c=500;
    for j=1:17
        x=[];
        y=[];
        x(1)=double(Arrival5(i,j));
        y(1)=c;
        x(2)=double(Departure5(i,j));
        y(2)=c;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j));
        y(1)=c;
        x(2)=double(Arrival5(i,j+1));
        y(2)=c-10;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j))+100;
        y(1)=c;
        x(2)=double(Departure5(i,j))+200;
        y(2)=c;
        x(3)=double(Departure5(i,j))+200;
        y(3)=c-double(Qstranded_line5_left(i,j))/500;
        x(4)=double(Departure5(i,j))+100;
        y(4)=c-double(Qstranded_line5_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line5_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000 %stranded passenger 2000~4000
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
        x(1)=double(Arrival5(i,j));
        y(1)=c;
        x(2)=double(Departure5(i,j));
        y(2)=c;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j));
        y(1)=c;
        x(2)=double(Arrival5(i,j+1));
        y(2)=c-10;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j))+100;
        y(1)=c;
        x(2)=double(Departure5(i,j))+200;
        y(2)=c;
        x(3)=double(Departure5(i,j))+200;
        y(3)=c-double(Qstranded_line5_left(i,j))/500;
        x(4)=double(Departure5(i,j))+100;
        y(4)=c-double(Qstranded_line5_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line5_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000 %stranded passenger 2000~4000
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
        x(1)=double(Arrival5(i,j));
        y(1)=10;
        x(2)=double(Departure5(i,j));
        y(2)=10;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j));
        y(1)=10;
        x(2)=double(Arrival5(i,j+1));
        y(2)=0;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5 %full load rate 0%~50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6 %full load rate 50%~60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7 %full load rate 60%~70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8 %full load rate 70%~80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9 %full load rate 80%~90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1 %full load rate 90%~100%
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
        x(1)=double(Departure5(i,j))+100;
        y(1)=10;
        x(2)=double(Departure5(i,j))+200;
        y(2)=10;
        x(3)=double(Departure5(i,j))+200;
        y(3)=10-double(Qstranded_line5_left(i,j))/500;
        x(4)=double(Departure5(i,j))+100;
        y(4)=10-double(Qstranded_line5_left(i,j))/500;
        x(5)=x(1);
        y(5)=y(1);
        if double(Qstranded_line5_left(i,j))<=300 %stranded passenger 0~300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500 %stranded passenger 300~500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000 %stranded passenger 500~1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000 %stranded passenger 1000~2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000 %stranded passenger 2000~4000
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