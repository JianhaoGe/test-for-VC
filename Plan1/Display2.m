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
set(gca,'yticklabel',["Yishan Road","Hongqiao Road","Shanghai South Railway Station","Shilong Road","Longcao Road","Caoxi Road","Yishan Road","Hongqiao Road","West Yan'an Road","Zhongshan Park","Jinshajiang Road","Caoyang Road","Zhenping Road","Zhongtan Road","Shanghai Railway Station","Baoshan Road","Dongbaoxing Road","Hongkou Football Stadium","Chifeng Road","Dabaishu","Jiangwan Town","West Yingao Road","South Changjiang Road","Songfa Road","Zhanghuabang","Songbin Road","Shuichan Road","Baoyang Road","Youyi Road","Tieli Road","North Jiangyang Road","Baoshan Road","Hailun Road","Linping Road","Dalian Road","Yangshupu Road","Pudong Avenue","Century Avenue","Pudian Road","Lancun Road","Tangqiao","Nanpu Bridge","South Xizang Road","Luban Road","Damuqiao Road","Dong'an Road","Shanghai Gymnasium","Shanghai Stadium","Yishan Road"]);
set(gca,'xtick',[7*3600:600:10*3600]);
set(gca,'xticklabel',["7:00","7:10","7:20","7:30","7:40","7:50","8:00","8:10","8:20","8:30","8:40","8:50","9:00","9:10","9:20","9:30","9:40","9:50","10:00"]);
set(gca,'FontSize',6);
% set(gca,'ytick',[0,10,30,80,160,230,310,330,500]);
% set(gca,'yticklabel',["YSR","HQR","SHSRS","HQR","BSR","SCJR","NJYR","BSR","YSR"]);
% set(gca,'xtick',[7*3600:1800:10*3600]);
% set(gca,'xticklabel',["7:00","7:30","8:00","8:30","9:00","9:30","10:00"]);
% set(gca,'FontSize',8);

for i=1:Totaltrain1
    a=310;
    for j=1:28
        x=[];
        y=[];
        x(1)=double(Arrival1(i,j));
        y(1)=a;
        x(2)=double(Departure1(i,j));
        y(2)=a;
        plot(x,y,'b');
        hold on
        x=[];
        y=[];
        x(1)=double(Departure1(i,j));
        y(1)=a;
        x(2)=double(Arrival1(i,j+1));
        y(2)=a-10;
        plot(x,y,'b');
        hold on
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
        plot(x,y,'r');
        hold on
        x=[];
        y=[];
        x(1)=double(Departure5(i,j));
        y(1)=c;
        x(2)=double(Arrival5(i,j+1));
        y(2)=c-10;
        plot(x,y,'r');
        hold on
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
        plot(x,y,'r');
        hold on
        x=[];
        y=[];
        x(1)=double(Departure5(i,j));
        y(1)=c;
        x(2)=double(Arrival5(i,j+1));
        y(2)=c-10;
        plot(x,y,'r');
        hold on
        c=c-10;
    end
    j=j+1;
        x=[];
        y=[];
        x(1)=double(Arrival5(i,j));
        y(1)=10;
        x(2)=double(Departure5(i,j));
        y(2)=10;
        plot(x,y,'r');
        hold on
        x=[];
        y=[];
        x(1)=double(Departure5(i,j));
        y(1)=10;
        x(2)=double(Arrival5(i,j+1));
        y(2)=0;
        plot(x,y,'r');
        hold on
end
axis([7*3600 9.3*3600 0 500]);