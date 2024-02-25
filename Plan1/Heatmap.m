Data3=zeros(28,30);
Data4=zeros(26,30);
Y3value=[
    "NJYR - TLR";
    "TLR - YYR";
    "YYR - BYR";
    "BYR - SCR";
    "SCR - SBR";
    "SBR - ZHB";
    "ZHB - SFR ";
    "SFR - SCJR";
    "SCJR - WYGR";
    "WYGR - JWT";
    "JWT - DBS";
    "DBS - CFR";
    "CFR - HKFS";
    "HKFS - DBXR";
    "DBXR - BSR";
    "BSR - SHRS";
    "SHRS - ZTR";
    "ZTR - ZPR";
    "ZPR - CYR";
    "CYR - JSJR";
    "JSJR - ZSP";
    "ZSP - WYAR";
    "WYAR - HQR";
    "HQR - YSR";
    "YSR - CXR";
    "CXR - LCR";
    "LCR - SLR";
    "SLR - SHSRS";
    ];
Y4value=[
    "YSR - SHS";
    "SHS - SHG";
    "SHG - DAR";
    "DAR - DMQR";
    "DMQR - LBR";
    "LBR - SXZR";
    "SXZR - NPB";
    "NPB - TQ";
    "TQ - LCR";
    "LCR - PDR";
    "PDR - CA";
    "CA - PDA";
    "PDA - YSPR";
    "YSPR - DLR";
    "DLR - LPR";
    "LPR - HLR";
    "HLR - BSR";
    "BSR - SHRS";
    "SHRS - ZTR";
    "ZTR - ZPR";
    "ZPR - CYR";
    "CYR - JSJR";
    "JSJR - ZSP";
    "ZSP - WYAR";
    "WYAR - HQR";
    "HQR - YSR";
    ];
Xvalue=[
    "7:00-7:05";
    "7:05-7:10";
    "7:10-7:15";
    "7:15-7:20";
    "7:20-7:25";
    "7:25-7:30";
    "7:30-7:35";
    "7:35-7:40";
    "7:40-7:45";
    "7:45-7:50";
    "7:50-7:55";
    "7:55-8:00";
    "8:00-8:05";
    "8:05-8:10";
    "8:10-8:15";
    "8:15-8:20";
    "8:20-8:25";
    "8:25-8:30";
    "8:30-8:35";
    "8:35-8:40";
    "8:40-8:45";
    "8:45-8:50";
    "8:50-8:55";
    "8:55-9:00";
    "9:00-9:05";
    "9:05-9:10";
    "9:10-9:15";
    "9:15-9:20";
    "9:20-9:25";
    "9:25-9:30";
];

load("result.mat")
Qblock_line1=Qinvehicle_line1_left(:,1:28)+Qboard_line1_left;
Qblock_line5=Qinvehicle_line5_left(:,1:26)+Qboard_line5_left;
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
        for i=1:size(Qblock_line5,1)
            if Departure5(i,a)>=7*3600+(k-1)*300 && Departure5(i,a)<7*3600+k*300
                Num4(a,k)=Num4(a,k)+1;
                Data4(a,k)=Data4(a,k)+Qblock_line5(i,a);
            end
            if Departure5(i,a+1)>=7*3600+(k-1)*300 && Departure5(i,a+1)<7*3600+k*300
                Num4(a,k)=Num4(a,k)+1;
                Data4(a,k)=Data4(a,k)+Qblock_line5(i,a);
            end
            if Departure5(i,a)>=7*3600+(k-1)*300 && Departure5(i,a)<7*3600+k*300 && Departure5(i,a+1)>=7*3600+(k-1)*300 && Departure5(i,a+1)<7*3600+k*300
                Num4(a,k)=Num4(a,k)-1;
                Data4(a,k)=Data4(a,k)-Qblock_line5(i,a);
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
     "YSR - SHS";
    "SHS - SHG";
    "SHG - DAR";
    "DAR - DMQR";
    "DMQR - LBR";
    "LBR - SXZR";
    "SXZR - NPB";
    "NPB - TQ";
    "TQ - LCR";
    "LCR - PDR";
    "PDR - CA";
    "CA - PDA";
    "PDA - YSPR";
    "YSPR - DLR";
    "DLR - LPR";
    "LPR - HLR";
    "HLR - BSR";
    "1";
    "2";
    "NJYR - TLR";
    "TLR - YYR";
    "YYR - BYR";
    "BYR - SCR";
    "SCR - SBR";
    "SBR - ZHB";
    "ZHB - SFR ";
    "SFR - SCJR";
    "SCJR - WYGR";
    "WYGR - JWT";
    "JWT - DBS";
    "DBS - CFR";
    "CFR - HKFS";
    "HKFS - DBXR";
    "DBXR - BSR";
    "BSR - SHRS";
    "SHRS - ZTR";
    "ZTR - ZPR";
    "ZPR - CYR";
    "CYR - JSJR";
    "JSJR - ZSP";
    "ZSP - WYAR";
    "WYAR - HQR";
    "HQR - YSR for Line 3";
    "YSR - CXR";
    "CXR - LCR";
    "LCR - SLR";
    "SLR - SHSRS";
    "3";
    "4";
    "HQR - YSR for Line 4";
    ];
DD(DD<0)=1;
L=heatmap(Xvalue,Yvalue,DD);