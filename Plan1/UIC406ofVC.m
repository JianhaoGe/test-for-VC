load('result.mat');

%% Arrival_1 and Arrival_2 represent the arrival times of trains after compression.
%% Departure_1 and Departure_2 represent the departure times of trains after compression.
Arrival_1=Arrival1;
Arrival_2=Arrival2;
Departure_1=Departure1;
Departure_2=Departure2;
Compression=zeros(1,39);
kk=zeros(1,39);

%% The method is the same as the algorithm introduced in Fig.7. 
%% Binary variable VCor12 represents whether the train of Line 1 is virtually coupled with its front train or its rear train.
ii=0;
for i=1:19
    ii=ii+1;
    if i==1
    if VCor12(i,1)==0
        Compression(ii)=min(Departure_2(i,18:26)-Departure_1(i,16:24))-30;
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
            end
        end
        if min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24))~=0
            kk(ii)=min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24));
            Departure_1(i,:)=Departure_1(i,:)+kk(ii);
            Arrival_1(i,:)=Arrival_1(i,:)+kk(ii);
        end
    else
        if VCor12(i,1)==1
            Compression(ii)=min(Departure_2(i,18:26)-Departure_1(i,16:24))-120;
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
            end
        end
        end
    end
    else
        if i>1
            if VCor12(i,1)==0
                 Compression(ii)=min([Departure_2(i,18:26)-Departure_1(i,16:24)-30,Departure_2(i,1:end-1)-Departure_2(i-1,1:end-1)-120]);
                 if Compression(ii)<0
                     disp('Warning!');
                 else
                     if Compression(ii)>0
                         Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                         Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
                     end
                 end
                 if min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24))~=0
                     kk(ii)=min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24));
                     Departure_1(i,:)=Departure_1(i,:)+kk(ii);
                     Arrival_1(i,:)=Arrival_1(i,:)+kk(ii);
                 end
            else
                 if VCor12(i,1)==1
                     Compression(ii)=min([Departure_2(i,18:26)-Departure_1(i,16:24)-120,Departure_2(i,1:end-1)-Departure_2(i-1,1:end-1)-120]);
                     if Compression(ii)<0
                         disp('Warning!');
                     else
                         if Compression(ii)>0
                              Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                              Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
                         end
                     end
                end
            end
        end     
    end
    ii=ii+1;
    if VCor12(i+1,2)==0
        Compression(ii)=min([Departure_1(i+1,16:24)-Departure_2(i,18:26)-30,Departure_1(i+1,1:end-1)-Departure_1(i,1:end-1)-120]);
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_1(i+1,:)=Departure_1(i+1,:)-Compression(ii);
                Arrival_1(i+1,:)=Arrival_1(i+1,:)-Compression(ii);
            end
        end
        if min(Departure_1(i+1,16:24)-Departure_2(i,18:26))-min(Departure1(i+1,16:24)-Departure2(i,18:26))~=0
            kk(ii)=min(Departure_1(i+1,16:24)-Departure_2(i,18:26))-min(Departure1(i+1,16:24)-Departure2(i,18:26));
            Departure_2(i,:)=Departure_2(i,:)+kk(ii);
            Arrival_2(i,:)=Arrival_2(i,:)+kk(ii);
        end
    else
        if VCor12(i+1,2)==1
            Compression(ii)=min([Departure_1(i+1,16:24)-Departure_2(i,18:26)-120,Departure_1(i+1,1:end-1)-Departure_1(i,1:end-1)-120]);
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_1(i+1,:)=Departure_1(i+1,:)-Compression(ii);
                Arrival_1(i+1,:)=Arrival_1(i+1,:)-Compression(ii);
            end
        end
        end
    end
end
i=i+1;
ii=ii+1;
    if VCor12(i,1)==0
        Compression(ii)=min([Departure_2(i,18:26)-Departure_1(i,16:24)-30,Departure_2(i,1:end-1)-Departure_2(i-1,1:end-1)-120]);
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
            end
        end
        if min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24))~=0
            kk(ii)=min(Departure_2(i,18:26)-Departure_1(i,16:24))-min(Departure2(i,18:26)-Departure1(i,16:24));
            Departure_1(i,:)=Departure_1(i,:)+kk(ii);
            Arrival_1(i,:)=Arrival_1(i,:)+kk(ii);
        end
    else
        if VCor12(i,1)==1
            Compression(ii)=min([Departure_2(i,18:26)-Departure_1(i,16:24)-120,Departure_2(i,1:end-1)-Departure_2(i-1,1:end-1)-120]);
        if Compression(ii)<0
            disp('Warning!');
        else
            if Compression(ii)>0
                Departure_2(i,:)=Departure_2(i,:)-Compression(ii);
                Arrival_2(i,:)=Arrival_2(i,:)-Compression(ii);
            end
        end
        end
    end
            
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

for i=1:20
    a=310;
    for j=1:15
        x=[];
        y=[];
        x(1)=double(Departure_1(i,j))-60;
        y(1)=a;
        x(2)=double(Departure_1(i,j))+60;
        y(2)=a;
        x(3)=double(Arrival_1(i,j+1))+60;
        y(3)=a-10;
        x(4)=double(Arrival_1(i,j+1))-60;
        y(4)=a-10;
        x(5)=x(1);
        y(5)=y(1);
        fill(x,y,'c');
        hold on
        x=[];
        y=[];
        x(1)=double(Arrival_1(i,j));
        y(1)=a;
        x(2)=double(Departure_1(i,j));
        y(2)=a;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_1(i,j));
        y(1)=a;
        x(2)=double(Arrival_1(i,j+1));
        y(2)=a-10;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        a=a-10;
    end
    for j=16:23
        x=[];
        y=[];
        if VCor12(i,1)==0
            x(1)=double(Departure_1(i,j))-60;
            y(1)=a;
            x(2)=double(Departure_2(i,j+2))+60;
            y(2)=a;
            x(3)=double(Arrival_2(i,j+3))+60;
            y(3)=a-10;
            x(4)=double(Arrival_1(i,j+1))-60;
            y(4)=a-10;
            x(5)=x(1);
            y(5)=y(1);
            fill(x,y,'c');        
            hold on
        else
            if VCor12(i,2)==0 && i>1
                x(1)=double(Departure_1(i,j))+60;
                y(1)=a;
                x(2)=double(Departure_2(i-1,j+2))-60;
                y(2)=a;
                x(3)=double(Arrival_2(i-1,j+3))-60;
                y(3)=a-10;
                x(4)=double(Arrival_1(i,j+1))+60;
                y(4)=a-10;
                x(5)=x(1);
                y(5)=y(1);
                fill(x,y,'c');        
                hold on
            else
                x(1)=double(Departure_1(i,j))-60;
                y(1)=a;
                x(2)=double(Departure_1(i,j))+60;
                y(2)=a;
                x(3)=double(Arrival_1(i,j+1))+60;
                y(3)=a-10;
                x(4)=double(Arrival_1(i,j+1))-60;
                y(4)=a-10;
                x(5)=x(1);
                y(5)=y(1);
                fill(x,y,'c');
                hold on
            end
        end
        x=[];
        y=[];
        x(1)=double(Arrival_1(i,j));
        y(1)=a;
        x(2)=double(Departure_1(i,j));
        y(2)=a;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_1(i,j));
        y(1)=a;
        x(2)=double(Arrival_1(i,j+1));
        y(2)=a-10;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        a=a-10;
    end
    for j=24:28
        x=[];
        y=[];
        x(1)=double(Departure_1(i,j))-60;
        y(1)=a;
        x(2)=double(Departure_1(i,j))+60;
        y(2)=a;
        x(3)=double(Arrival_1(i,j+1))+60;
        y(3)=a-10;
        x(4)=double(Arrival_1(i,j+1))-60;
        y(4)=a-10;
        x(5)=x(1);
        y(5)=y(1);
        fill(x,y,'c');
        hold on
        x=[];
        y=[];
        x(1)=double(Arrival_1(i,j));
        y(1)=a;
        x(2)=double(Departure_1(i,j));
        y(2)=a;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_1(i,j));
        y(1)=a;
        x(2)=double(Arrival_1(i,j+1));
        y(2)=a-10;
        plot(x,y,'-','Color',[0 0 0],'LineWidth',1.5);
        hold on
        a=a-10;
    end
end
for i=1:20
    c=500;
    for j=1:17
        x=[];
        y=[];
        x(1)=double(Departure_2(i,j))-60;
        y(1)=c;
        x(2)=double(Departure_2(i,j))+60;
        y(2)=c;
        x(3)=double(Arrival_2(i,j+1))+60;
        y(3)=c-10;
        x(4)=double(Arrival_2(i,j+1))-60;
        y(4)=c-10;
        x(5)=x(1);
        y(5)=y(1);
        fill(x,y,'c');
        hold on
        x=[];
        y=[];
        x(1)=double(Arrival_2(i,j));
        y(1)=c;
        x(2)=double(Departure_2(i,j));
        y(2)=c;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_2(i,j));
        y(1)=c;
        x(2)=double(Arrival_2(i,j+1));
        y(2)=c-10;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
        c=c-10;
    end
    c=160;
    for j=18:25
        if i<20
        if VCor12(i,1)==1 && VCor12(i+1,2)==1
                x=[];
                y=[];
                x(1)=double(Departure_2(i,j))-60;
                y(1)=c;
                x(2)=double(Departure_2(i,j))+60;
                y(2)=c;
                x(3)=double(Arrival_2(i,j+1))+60;
                y(3)=c-10;
                x(4)=double(Arrival_2(i,j+1))-60;
                y(4)=c-10;
                x(5)=x(1);
                y(5)=y(1);
                fill(x,y,'c');
                hold on
        end
        end
        if i==20
                x=[];
                y=[];
                x(1)=double(Departure_2(i,j))-60;
                y(1)=c;
                x(2)=double(Departure_2(i,j))+60;
                y(2)=c;
                x(3)=double(Arrival_2(i,j+1))+60;
                y(3)=c-10;
                x(4)=double(Arrival_2(i,j+1))-60;
                y(4)=c-10;
                x(5)=x(1);
                y(5)=y(1);
                fill(x,y,'c');
                hold on
        end
        x=[];
        y=[];
        x(1)=double(Arrival_2(i,j));
        y(1)=c;
        x(2)=double(Departure_2(i,j));
        y(2)=c;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_2(i,j));
        y(1)=c;
        x(2)=double(Arrival_2(i,j+1));
        y(2)=c-10;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
        c=c-10;
    end
    j=j+1;
            x=[];
        y=[];
        x(1)=double(Departure_2(i,j))-60;
        y(1)=10;
        x(2)=double(Departure_2(i,j))+60;
        y(2)=10;
        x(3)=double(Arrival_2(i,j+1))+60;
        y(3)=0;
        x(4)=double(Arrival_2(i,j+1))-60;
        y(4)=0;
        x(5)=x(1);
        y(5)=y(1);
        fill(x,y,'c');
        hold on
        x=[];
        y=[];
        x(1)=double(Arrival_2(i,j));
        y(1)=10;
        x(2)=double(Departure_2(i,j));
        y(2)=10;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
        x=[];
        y=[];
        x(1)=double(Departure_2(i,j));
        y(1)=10;
        x(2)=double(Arrival_2(i,j+1));
        y(2)=0;
        plot(x,y,'-','Color',[1 0 0],'LineWidth',1.5);
        hold on
end
axis([7*3600 10*3600 0 500]);
Ct(1)=plot(NaN,NaN,'Color',[0 0 0],'LineWidth',1.5);
Ct(2)=plot(NaN,NaN,'Color',[1 0 0],'LineWidth',1.5);
Ct(3)=fill(NaN,NaN,'c');
legend(Ct,'Train path of Line 1','Train path of Line 2','Infrastructure occupation time');
xlabel('Time');ylabel('Station');
UIC4061=(Departure_1(end,1)-Departure_1(1,1))/(Departure1(end,1)-Departure1(1,1));
UIC4062=(Departure_2(end,1)-Departure_2(1,1))/(Departure2(end,1)-Departure2(1,1));
UIC406z=(Departure_1(end,1)-Departure_1(1,1)+Departure_2(end,1)-Departure_2(1,1))/(Departure1(end,1)-Departure1(1,1)+Departure2(end,1)-Departure2(1,1));
    
deltaD1=Departure1-Departure_1;
deltaD2=Departure2-Departure_2;
for i=1:20
    deltaD(2*i-1,1)=deltaD1(i,1);
    deltaD(2*i,1)=deltaD2(i,1);
end
delta11=deltaD(2:end,1)-deltaD(1:end-1,1);
