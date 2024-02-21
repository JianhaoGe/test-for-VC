% Data=zeros(46,30);
% Yvalue=[
%     "Shanghai South Railway Station";
%     "Shilong Road";
%     "Longcao Road";
%     "Caoxi Road";
%     "Yishan Road";
%     "Hongqiao Road";
%     "West Yan'an Road";
%     "Zhongshan Park";
%     "Jinshajiang Road";
%     "Caoyang Road";
%     "Zhenping Road";
%     "Zhongtan Road";
%     "Shanghai Railway Station";
%     "Baoshan Road";
%     "Dongbaoxing Road";
%     "Hongkou Football Stadium";
%     "Chifeng Road";
%     "Dabaishu";
%     "Jiangwan Town";
%     "West Yingao Road";
%     "South Changjiang Road";
%     "Songfa Road";
%     "Zhanghuabang";
%     "Songbin Road";
%     "Shuichan Road";
%     "Baoyang Road";
%     "Youyi Road";
%     "Tieli Road";
%     "North Jiangyang Road";
%     "medium";
%     "Hailun Road";
%     "Linping Road";
%     "Dalian Road";
%     "Yangshupu Road";
%     "Pudong Avenue";
%     "Century Avenue";
%     "Pudian Road";
%     "Lancun Road";
%     "Tangqiao";
%     "Nanpu Bridge";
%     "South Xizang Road";
%     "Luban Road";
%     "Damuqiao Road";
%     "Dong'an Road";
%     "Shanghai Gymnasium";
%     "Shanghai Stadium";
%     ];
Data3=zeros(28,30);
Data4=zeros(26,30);
% Y3value=[
%     "Shanghai South Railway Station - Shilong Road";
%     "Shilong Road - Longcao Road";
%     "Longcao Road - Caoxi Road";
%     "Caoxi Road - Yishan Road";
%     "Yishan Road - Hongqiao Road";
%     "Hongqiao Road - West Yan'an Road";
%     "West Yan'an Road - Zhongshan Park";
%     "Zhongshan Park - Jinshajiang Road";
%     "Jinshajiang Road - Caoyang Road";
%     "Caoyang Road - Zhenping Road";
%     "Zhenping Road - Zhongtan Road";
%     "Zhongtan Road - Shanghai Railway Station";
%     "Shanghai Railway Station - Baoshan Road";
%     "Baoshan Road - Dongbaoxing Road";
%     "Dongbaoxing Road - Hongkou Football Stadium";
%     "Hongkou Football Stadium - Chifeng Road";
%     "Chifeng Road - Dabaishu";
%     "Dabaishu - Jiangwan Town";
%     "Jiangwan Town - West Yingao Road";
%     "West Yingao Road - South Changjiang Road";
%     "South Changjiang Road - Songfa Road";
%     "Songfa Road - Zhanghuabang";
%     "Zhanghuabang - Songbin Road";
%     "Songbin Road - Shuichan Road";
%     "Shuichan Road - Baoyang Road";
%     "Baoyang Road - Youyi Road";
%     "Youyi Road - Tieli Road";
%     "Tieli Road - North Jiangyang Road";
%     ];
% Y3value=flipud(Y3value);
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
% Y4value=[
%     "Yishan Road - Hongqiao Road";
%     "Hongqiao Road - West Yan'an Road";
%     "West Yan'an Road - Zhongshan Park";
%     "Zhongshan Park - Jinshajiang Road";
%     "Jinshajiang Road - Caoyang Road";
%     "Caoyang Road - Zhenping Road";
%     "Zhenping Road - Zhongtan Road";
%     "Zhongtan Road - Shanghai Railway Station";
%     "Shanghai Railway Station - Baoshan Road";
%     "Baoshan Road - Hailun Road";
%     "Hailun Road - Linping Road";
%     "Linping Road - Dalian Road";
%     "Dalian Road - Yangshupu Road";
%     "Yangshupu Road - Pudong Avenue";
%     "Pudong Avenue - Century Avenue";
%     "Century Avenue - Pudian Road";
%     "Pudian Road - Lancun Road";
%     "Lancun Road - Tangqiao";
%     "Tangqiao - Nanpu Bridge";
%     "Nanpu Bridge - South Xizang Road";
%     "South Xizang Road - Luban Road";
%     "Luban Road - Damuqiao Road";
%     "Damuqiao Road - Dong'an Road";
%     "Dong'an Road - Shanghai Gymnasium";
%     "Shanghai Gymnasium - Shanghai Stadium";
%     "Shanghai Stadium - Yishan Road";
%     ];
% Y4value=flipud(Y4value);
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

% for a=2:29
%     for k=1:30
%         for i=1:22
%             if Departure1(i,30-a)>=7*3600+(k-1)*300 && Departure1(i,30-a)<7*3600+k*300
%                 Data(a,k)=Data(a,k)+Qstranded_line1_left(i,30-a);
%             end
%         end
%         if a<=21
%             if Departure3(1,22-a)>=7*3600+(k-1)*300 && Departure3(1,22-a)<7*3600+k*300
%                 Data(a,k)=Data(a,k)+Qstranded_line3_left(1,22-a);
%             end
%         end
%         if a==5
%             for i=1:19
%                 if Departure5(i,1)>=7*3600+(k-1)*300 && Departure5(i,1)<7*3600+k*300
%                     Data(a,k)=Data(a,k)+Qstranded_line5_left(i,1);
%                 end
%             end
%         end 
%         if a>5&&a<=14
%             for i=1:19
%                 if Departure5(i,32-a)>=7*3600+(k-1)*300 && Departure5(i,32-a)<7*3600+k*300
%                     Data(a,k)=Data(a,k)+Qstranded_line5_left(i,32-a);
%                 end
%             end
%         end 
%     end
% end
% 
% for a=31:46
%     for k=1:30
%         for i=1:19
%            if Departure5(i,48-a)>=7*3600+(k-1)*300 && Departure5(i,48-a)<7*3600+k*300
%                Data(a,k)=Data(a,k)+Qstranded_line5_left(i,48-a);
%            end
%         end
%     end
% end
% Data=fix(Data);
% L=heatmap(Xvalue,Yvalue,Data);
Qblock_line1=Qinvehicle_line1_left(:,1:28)+Qboard_line1_left;
Qblock_line3=Qinvehicle_line3_left(:,1:20)+Qboard_line3_left;
Qblock_line5=Qinvehicle_line5_left(:,1:26)+Qboard_line5_left;
Num3=zeros(28,30);
Num4=zeros(26,30);
DD3=[];
DD4=[];
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
        if a>8
        for i=1:size(Qblock_line3,1)
        if Departure3(i,a-8)>=7*3600+(k-1)*300 && Departure3(i,a-8)<7*3600+k*300
            Num3(a,k)=Num3(a,k)+1;
            Data3(a,k)=Data3(a,k)+Qblock_line3(i,a-8);
        end
        if Departure3(i,a+1-8)>=7*3600+(k-1)*300 && Departure3(i,a+1-8)<7*3600+k*300
            Num3(a,k)=Num3(a,k)+1;
            Data3(a,k)=Data3(a,k)+Qblock_line3(i,a-8);
        end
        if Departure3(i,a-8)>=7*3600+(k-1)*300 && Departure3(i,a-8)<7*3600+k*300 && Departure3(i,a+1-8)>=7*3600+(k-1)*300 && Departure3(i,a+1-8)<7*3600+k*300
            Num3(a,k)=Num3(a,k)-1;
            Data3(a,k)=Data3(a,k)-Qblock_line3(i,a-8);
        end
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
for a=1:28
    for k=1:30
        if 7*3600+k*300<Departure1(1,a)
            DD3(a,k)=D3(a,k);
        end
        if a<=8
            if 7*3600+(k-1)*300>Departure1(end,a)
                DD3(a,k)=D3(a,k);
            end
        else if a>8
                if 7*3600+(k-1)*300>max(Departure1(end,a),Departure3(end,a-8))
                    DD3(a,k)=D3(a,k);
                end
            end
        end
    end
end
for a=1:26
    for k=1:30
        if 7*3600+k*300<Departure5(1,a)
            DD4(a,k)=D4(a,k);
        end
        if 7*3600+(k-1)*300>Departure5(end,a)
            DD4(a,k)=D4(a,k);
        end
    end
end

% L3=heatmap(Xvalue,Y3value,DD3);
% L4=heatmap(Xvalue,Y4value,DD4);
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