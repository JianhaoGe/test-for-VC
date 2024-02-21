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








for i=1:Totaltrain1
    a=310;
    for j=1:28
        x=[];
        y=[];
        x(1)=double(Arrival1(i,j));
        y(1)=a;
        x(2)=double(Departure1(i,j));
        y(2)=a;
        if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line1_left(i,j))+double(Qboard_line1_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qstranded_line1_left(i,j))<=300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line1_left(i,j))<=500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line1_left(i,j))<=1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line1_left(i,j))<=2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line1_left(i,j))<=4000
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
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qstranded_line5_left(i,j))<=300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000
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
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qstranded_line5_left(i,j))<=300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000
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
        c=c-10;
    end
    j=j+1;
        x=[];
        y=[];
        x(1)=double(Arrival5(i,j));
        y(1)=10;
        x(2)=double(Departure5(i,j));
        y(2)=10;
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.5%满载率小于50%
            color=[0.13333,0.5451,0.13333];
        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.6%满载率小于60%
                color=[0.67843,1,0.18431];
            else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.7%满载率小于70%
                    color=[1,0.84314,0];
                else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.8%满载率小于80%
                        color=[0.95686,0.64314,0.37647];
                    else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*0.9%满载率小于90%
                            color=[0.94118,0.50196,0.50196];
                        else if double(Qinvehicle_line5_left(i,j))+double(Qboard_line5_left(i,j))<=TrainCapacity*1%满载率小于100%
                                color=[0.69804,0.13333,0.13333];
                            else 
                                color=[1,0,0];
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
        if double(Qstranded_line5_left(i,j))<=300
            fill(x,y,'g');
            hold on
        else if double(Qstranded_line5_left(i,j))<=500
                fill(x,y,'c');
                hold on
            else if double(Qstranded_line5_left(i,j))<=1000
                    fill(x,y,'y');
                    hold on
                else if double(Qstranded_line5_left(i,j))<=2000
                        fill(x,y,'b');
                        hold on
                     else if double(Qstranded_line5_left(i,j))<=4000
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