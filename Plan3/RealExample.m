clc;clear all;
totaltrain=59;
totalstation=13;
Capacity=258;    %每节编组的额定载客量
full_load_rate=1;    %满载率约束值
average_q_cost=1000; 
load("Timetable_d");
load("Timetable_a");
load('AFC.mat'); %%输入乘客需求信息jjisujisuanqi
T=43199-25199;
passengerdemand_down=zeros(totalstation,totalstation,T);
passengerdemand_up=zeros(totalstation,totalstation,T);
demand1=zeros(totalstation,T);
demand2=zeros(totalstation,T);
for n=1:121814
    t=AFC(n,5);
    if t>=25200 && t<=43199
        t1=t-25199;
        O=AFC(n,2)-1620; %1621龙阳路站，1634滴水湖站
        D=AFC(n,6)-1620; %滴水湖-龙阳路（up），龙阳路-滴水湖（down）
        if O<D   %%%先取下行方向
            passengerdemand_down(O,D,t1)=passengerdemand_down(O,D,t1)+1;
            demand1(O,t1)=demand1(O,t1)+1;
        else   %上行方向
            O=totalstation-O+1;
            D=totalstation-D+1;
            passengerdemand_up(O,D,t1)=passengerdemand_up(O,D,t1)+1;
            demand2(D,t1)=demand2(D,t1)+1;
        end
    end
end
passengerdemand_up=passengerdemand_up*1.5;
%%%%确定各趟车次的发车次序
arf=zeros(totaltrain,totaltrain,totalstation);  %%%列车发车次序鉴定
bta=zeros(totaltrain,totalstation);  
for k=1:totalstation
    for i=1:totaltrain
        count=1;
        for j=1:totaltrain
            if i~=j
                if Timetable_d(i,k)>Timetable_d(j,k)
                    arf(i,j,k)=1;
                else
                    arf(i,j,k)=0;    
                end
            else
            end
        end
    end
end
n=sum(arf,2);
bta=squeeze(n)+1;
Cremaind=zeros(totaltrain,totalstation);
Alight=zeros(totaltrain,totalstation);
Board=zeros(totaltrain,totalstation);
board=zeros(totaltrain,totalstation-1,totalstation);
Arrival=zeros(totaltrain,totalstation);
arrival=zeros(totaltrain,totalstation,totalstation);
Stranded=zeros(totaltrain,totalstation);
Invehicle=zeros(totaltrain,totalstation);
Wait=zeros(totaltrain,totalstation);
x=[1 1 0 0 1 0 1 0 0 0 1 0 1];   %大站车停车站点示意集合，1表示停车，0表示不停
for o=1:totaltrain
    for k=1:totalstation-1
        [m1,m2]=find(bta==o);
        i=m1(k);               
        if k==1
            Cremaind(i,k)=Capacity*6;
            Alight(i,k)=0;
        else
            Cremaind(i,k)=Capacity*6-Invehicle(i,k-1)+ Alight(i,k);
            for v=1:k-1
               Alight(i,k)=Alight(i,k)+board(i,v,k);
            end
        end
         Cremaind(o,k)=Cremaind(i,k);
        if i==1
           a=Timetable_d(i,k)-150-25199;
        else
           a=Timetable_d(i-1,k)-25199;  
        end
        b=Timetable_d(i,k)-25199;
          for t=a+1:b
             for s=k+1:totalstation
                  arrival(o,k,s)=arrival(o,k,s)+passengerdemand_up(k,s,t);
             end
          end
           Arrival(o,k)=sum(arrival(o,k,:));
        if o==1
            Wait(o,k)=Arrival(o,k);
        else
            Wait(o,k)=Arrival(o,k)+Stranded(o-1,k);
        end
        if i==48||i==59  %%%大站快车
            if Cremaind(o,k)<Wait(o,k)
                Board(o,k)=Cremaind(o,k)*x(1,k);
            else
                Board(o,k)=Wait(o,k)*x(1,k);
            end
            Board(i,k)=Board(o,k);
            for s=k+1:totalstation
                 board(o,k,s)=board(o,k,s)+ Board(o,k)*(arrival(o,k,s)/ Arrival(o,k))*x(1,s);
                 board(i,k,s)=board(o,k,s);
            end
        else  if i==3||i==9||i==13  %%%出库车
                if k==1||k==2||k==3
                   Board(o,k)=0;
                   board(i,k,:)=0;
                 else 
                    if Cremaind(o,k)<Wait(o,k)
                        Board(o,k)=Cremaind(o,k);
                    else
                    Board(o,k)=Wait(o,k);
                    end
                    Board(i,k)=Board(o,k);
                    for s=k+1:totalstation
                        board(o,k,s)=board(o,k,s)+ Board(o,k)*(arrival(o,k,s)/ Arrival(o,k));
                        board(i,k,s)=board(o,k,s);
                    end
                 end
                else if i==45||i==54   %%%%入库车
                         if k==11||k==12||k==13
                             Board(o,k)=0;
                             board(i,k,:)=0;
                         else 
                             if Cremaind(o,k)<Wait(o,k)
                                 Board(o,k)=Cremaind(o,k);
                             else
                                 Board(o,k)=Wait(o,k);
                             end
                             Board(i,k)=Board(o,k);
                             for s=k+1:totalstation
                                 board(o,k,s)=board(o,k,s)+ Board(o,k)*(arrival(o,k,s)/ Arrival(o,k));
                                 board(i,k,s)=board(o,k,s);
                             end
                         end
                    else    
                         if Cremaind(o,k)<Wait(o,k)
                             Board(o,k)=Cremaind(o,k);
                         else
                              Board(o,k)=Wait(o,k);
                         end
                              Board(i,k)=Board(o,k);
                        for s=k+1:totalstation
                             board(o,k,s)=board(o,k,s)+ Board(o,k)*(arrival(o,k,s)/ Arrival(o,k));
                             board(i,k,s)=board(o,k,s);
                        end
                   end
            end
        end
        idx=find(isnan(board));
        board(idx)=0;
        if k==1
           Invehicle(i,k)=Board(i,k);
        else
           Invehicle(i,k)=Invehicle(i,k-1)-Alight(i,k)+Board(i,k);
        end  
        if o==1
           Stranded(o,k)=0; 
        else
           Stranded(o,k)=Wait(o,k)-Board(o,k);
        end
    end
    k=13;
    for v=1:k-1
        Alight(i,k)=Alight(i,k)+board(i,v,k);
    end   
end
%时刻表结果图
figure;
for i=1:totalstation-1%画基准线（车站线）
    b=i*1000;%*1000;
    plot([0,18000],[b,b]'-',','k');%确立线型为虚线，颜色为灰色画图
    hold on
end
 plot([0,18000],[1550,1550]'-',','k');%确立线型为虚线，颜色为灰色画图
 hold on
 plot([0,18000],[10500,10500]'-',','k');
% set(gca,'ytick',[0:12]);%调整纵坐标为车站名称
% set(gca,'yticklabel',["滴水湖站","临港大道站","书院站","惠南东站","惠南站","野生动物园站","新场站","航头东站","鹤沙航城站","周浦东站","罗山路站","华夏中路站","龙阳路站"]);
stationlocation=[0 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 11000 12000];
%%%画车线
for i=1:totaltrain
    if i==3||i==9||i==13
        plot([Timetable_a(i,3)-25199-220,Timetable_a(i,3)-25199],[stationlocation(1,3)-500,stationlocation(1,3)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
        hold on;
        for k=3:totalstation-1
             if  Invehicle(i,k)<=1548*0.5 %满载率小于50%
                  plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                  hold on;
                  plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                  hold on;
            else if Invehicle(i,k)>1548*0.5 && Invehicle(i,k)<=1548*0.6  %满载率（50%，60%]
                     plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                     hold on;
                     plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                     hold on;   
                 else if Invehicle(i,k)>1548*0.6&&Invehicle(i,k)<=1548*0.7 %满载率（60%，70%]
                        plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[1,0.84314,0],'LineWidth',1.5);
                        hold on;
                        plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[1,0.84314,0],'LineWidth',1.5);
                        hold on;   
                     else if Invehicle(i,k)>1548*0.7&&Invehicle(i,k)<=1548*0.8 %满载率（70%，80%]
                             plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                             hold on;
                             plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                             hold on;
                          else if Invehicle(i,k)>1548*0.8 &&Invehicle(i,k)<=1548*0.9 %满载率（80%，90%]
                                 plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                 hold on;
                                 plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                 hold on;    
                              else if Invehicle(i,k)>1548*0.9 %满载率>90%
                                   plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
                                 hold on;
                                 plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
                                 hold on;
                                  end
                            end
                        end
                    end
              end
          end
        end
    else if i==45||i==54
           for k=1:totalstation-3
               if  Invehicle(i,k)<=1548*0.5 %满载率小于50%
                   plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                   hold on;
                   plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                   hold on;
              else if Invehicle(i,k)>1548*0.5 && Invehicle(i,k)<=1548*0.6  %满载率（50%，60%]
                      plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                      hold on;
                      plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                      hold on;   
                  else if Invehicle(i,k)>1548*0.6&&Invehicle(i,k)<=1548*0.7 %满载率（60%，70%]
                          plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[1,0.84314,0],'LineWidth',1.5);
                          hold on;
                          plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[1,0.84314,0],'LineWidth',1.5);
                          hold on;   
                       else if Invehicle(i,k)>1548*0.7&&Invehicle(i,k)<=1548*0.8 %满载率（70%，80%]
                               plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                               hold on;
                               plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                               hold on;
                            else if Invehicle(i,k)>1548*0.8 &&Invehicle(i,k)<=1548*0.9 %满载率（80%，90%]
                                    plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                    hold on;
                                    plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                    hold on;    
                                 else if Invehicle(i,k)>1548*0.9 %满载率>90%
                                          plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
                                          hold on;
                                          plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.69804,0.13333,0.13333],1.5);
                                          hold on;
                                     end
                                end
                           end
                      end
                  end
               end
           end
         plot([Timetable_a(i,11)-25199,Timetable_d(i,11)-25199],[stationlocation(1,11),stationlocation(1,11)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
         hold on;  
         plot([Timetable_d(i,11)-25199,Timetable_d(i,11)-25199+240],[stationlocation(1,11),stationlocation(1,11)+500],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
         hold on; 
     else
        for k=1:totalstation-1
            if  Invehicle(i,k)<=1548*0.5 %满载率小于50%
                  plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                  hold on;
                  plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.13333,0.5451,0.13333],'LineWidth',1.5);
                  hold on;
            else if Invehicle(i,k)>1548*0.5 && Invehicle(i,k)<=1548*0.6  %满载率（50%，60%]
                     plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                     hold on;
                     plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.67843,1,0.18431],'LineWidth',1.5);
                     hold on;   
                 else if Invehicle(i,k)>1548*0.6&&Invehicle(i,k)<=1548*0.7 %满载率（60%，70%]
                        plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[1,0.84314,0],'LineWidth',1.5);
                        hold on;
                        plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[1,0.84314,0],'LineWidth',1.5);
                        hold on;   
                     else if Invehicle(i,k)>1548*0.7&&Invehicle(i,k)<=1548*0.8 %满载率（70%，80%]
                             plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                             hold on;
                             plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.95686,0.64314,0.37647],'LineWidth',1.5);
                             hold on;
                          else if Invehicle(i,k)>1548*0.8 &&Invehicle(i,k)<=1548*0.9 %满载率（80%，90%]
                                 plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                 hold on;
                                 plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.94118,0.50196,0.50196],'LineWidth',1.5);
                                 hold on;    
                              else if Invehicle(i,k)>1548*0.9 %满载率>90%
                                   plot([Timetable_a(i,k)-25199,Timetable_d(i,k)-25199],[stationlocation(1,k),stationlocation(1,k)],'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
                                 hold on;
                                 plot([Timetable_d(i,k)-25199,Timetable_a(i,k+1)-25199],[stationlocation(1,k),stationlocation(1,k+1)],'Color',[0.69804,0.13333,0.13333],'LineWidth',1.5);
                                 hold on;
                                  end
                            end
                        end
                     end
                end
             end
          end
      end
  end
end

%%
%标签
set(gca,'ytick',[0 1000 1500 2000 3000 4000 5000 6000 7000 8000 9000 10000 10500 11000 12000]);
set(gca,'yticklabel',["滴水湖站","临港大道站","治北停车场","书院站","惠南东站","惠南站","野生动物园站","新场站","航头东站","鹤沙航城站","周浦东站","罗山路站","川杨河停车场","华夏中路站","龙阳路站"]);
set(gca,'xtick',[0:1800:18000]);
set(gca,'xticklabel',["7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00"]);
            
     
                                     
            
