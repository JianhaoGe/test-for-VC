%% The code is for inspiration and reference only, and may not be applicable to all situations
Data3=zeros(28,30);
Data4=zeros(26,30);
Xvalue=[
    "7:00-7:02";
    "7:02-7:10";
    "7:10-7:12";
    "7:12-7:20";
    "7:20-7:22";
    "7:22-7:30";
    "7:30-7:32";
    "7:32-7:40";
    "7:40-7:42";
    "7:42-7:20";
    "7:20-7:22";
    "7:22-8:00";
    "8:00-8:02";
    "8:02-8:10";
    "8:10-8:12";
    "8:12-8:20";
    "8:20-8:22";
    "8:22-8:30";
    "8:30-8:32";
    "8:32-8:40";
    "8:40-8:42";
    "8:42-8:20";
    "8:20-8:22";
    "8:22-9:00";
    "9:00-9:02";
    "9:02-9:10";
    "9:10-9:12";
    "9:12-9:20";
    "9:20-9:22";
    "9:22-9:30";
];

load("result.mat")
Qblock_line1=Qinvehicle_line1_left(:,1:28)+Qboard_line1_left;
Qblock_line2=Qinvehicle_line2_left(:,1:26)+Qboard_line2_left;
Num3=zeros(28,30);
Num4=zeros(26,30);
for a=1:28
    for k=1:30
        for i=1:size(Qblock_line1,1)
            if Departure1(i,a)>=7*3600+(k-1)*300 && Departure1(i,a)<7*3600+k*300
                Num3(a,k)=Num3(a,k)+1;
                Data3(a,k)=Data3(a,k)+Qblock_line1(i,a);
            end
            if Departure1(i,a+1)>=7*3600+(k-1)*300 && Departure1(i,a+1)<7*3600+k*300
                Num3(a,k)=Num3(a,k)+1;
                Data3(a,k)=Data3(a,k)+Qblock_line1(i,a);
            end
            if Departure1(i,a)>=7*3600+(k-1)*300 && Departure1(i,a)<7*3600+k*300 && Departure1(i,a+1)>=7*3600+(k-1)*300 && Departure1(i,a+1)<7*3600+k*300
                Num3(a,k)=Num3(a,k)-1;
                Data3(a,k)=Data3(a,k)-Qblock_line1(i,a);
            end
        end
    end
end

for a=1:26
    for k=1:30
        for i=1:size(Qblock_line2,1)
            if Departure2(i,a)>=7*3600+(k-1)*300 && Departure2(i,a)<7*3600+k*300
                Num4(a,k)=Num4(a,k)+1;
                Data4(a,k)=Data4(a,k)+Qblock_line2(i,a);
            end
            if Departure2(i,a+1)>=7*3600+(k-1)*300 && Departure2(i,a+1)<7*3600+k*300
                Num4(a,k)=Num4(a,k)+1;
                Data4(a,k)=Data4(a,k)+Qblock_line2(i,a);
            end
            if Departure2(i,a)>=7*3600+(k-1)*300 && Departure2(i,a)<7*3600+k*300 && Departure2(i,a+1)>=7*3600+(k-1)*300 && Departure2(i,a+1)<7*3600+k*300
                Num4(a,k)=Num4(a,k)-1;
                Data4(a,k)=Data4(a,k)-Qblock_line2(i,a);
            end
        end
    end
end
Num3=Num3*340*6;
Num4=Num4*340*6;
Num3(Num3==0)=1;
Num4(Num4==0)=1;
DD3=Data3./Num3;
DD4=Data4./Num4;
DD=[DD4(1:17,:);zeros(2,30);DD3;zeros(2,30);DD4(end,:)];

Yvalue=[
     "1 - 2";
    "2 - 3";
    "3 - 4";
    "4 - 5";
    "5 - 6";
    "6 - 7";
    "7 - 8";
    "9 - 10";
    "10 - 11";
    "11 - 12";
    "12 - 13";
    "13 - 14";
    "14 - 15";
    "15 - 16";
    "16 - 17";
    "17 - 18";
    "18 - 19";
    "11111111111";
    "22222222222";
    "19 - 20";
    "20 - 21";
    "21 - 22";
    "22 - 23";
    "23 - 24";
    "24 - 25";
    "25 - 26";
    "26 - 27";
    "27 - 28";
    "28 - 29";
    "29 - 30";
    "30 - 31";
    "31 - 32";
    "32 - 33";
    "33 - 34";
    "34 - 35";
    "35 - 36";
    "36 - 37";
    "37 - 38";
    "38 - 39";
    "39 - 40";
    "40 - 41";
    "41 - 42";
    "42 - 43";
    "43 - 44";
    "44 - 45";
    "45 - 46";
    "46 - 47";
    "333333333333";
    "444444444444";
    "47 - 48";
    ];
DD(DD<0)=1;
L=heatmap(Xvalue,Yvalue,DD);
