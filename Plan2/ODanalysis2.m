% % load('Runningtime.mat');
% Stime=6*3600;
% Etime=24*3600;
% Timestamp=900;
% % Line1=Runningtime(Runningtime.Planning==5,:);
% % load('Passenger3.mat');
% AlightRate1=zeros(length(ID.VarName1)*length(ID.VarName1),(Etime-Stime)/Timestamp);
% for i=1:(Etime-Stime)/Timestamp
%     t=(i-1)*Timestamp+Stime;
%     for s=1:length(ID.VarName1)
%         for k=1:length(ID.VarName1)
%             j=(s-1)*length(ID.VarName1)+k;
%             od=All04(All04(:,7)>=t & All04(:,7)<=t+Timestamp-1 & All04(:,1)==s+401 & All04(:,3)==k+401,: );
%             p.number=length(od(:,1));
%             AlightRate1(j,i)=AlightRate1(j,i)+p.number;
%         end  
%     end    
% end
% nn=0;
% LineO=zeros(length(ID.VarName1)*length(ID.VarName1),1);
% LineD=zeros(length(ID.VarName1)*length(ID.VarName1),1);
% LineOO=strings(length(ID.VarName1)*length(ID.VarName1),1);
% LineDD=strings(length(ID.VarName1)*length(ID.VarName1),1);
% for i=1:length(ID.VarName1)
%     for j=1:length(ID.VarName1)
%         nn=nn+1;
% %         kk=find(ID.SHNZ==Line1.From(i,1));
% %         LineO(nn,1)=ID.VarName1(kk);
% %         LineOO(nn,1)=ID.VarName2(kk);
% %         kk2=find(ID.SHNZ==Line1.From(j,1));
% %         LineD(nn,1)=ID.VarName1(kk2);
% %         LineDD(nn,1)=ID.VarName2(kk2);
%           LineO(nn,1)=ID.VarName1(i);
%           LineOO(nn,1)=ID.VarName2(i);
%           LineD(nn,1)=ID.VarName1(j);
%           LineDD(nn,1)=ID.VarName2(j);
%     end
% end

Stime=6*3600;
Etime=24*3600;
Timestamp=900;
% Line1=Runningtime(Runningtime.Planning==5,:);
% load('Passenger3.mat');
kkk=unique(Line17OD.O_L_ID);
ID=length(kkk);
AlightRate1=zeros(ID*ID,(Etime-Stime)/Timestamp);
for i=1:(Etime-Stime)/Timestamp
    t=(i-1)*Timestamp+Stime;
    for s=1:ID
        for k=1:ID
            j=(s-1)*ID+k;
            od=Line17OD(Line17OD.SimInLineTime>=t & Line17OD.SimInLineTime<=t+Timestamp-1 & double(Line17OD.O_L_ID)==s+1720 & double(Line17OD.D_L_ID)==k+1720,:);
            p.number=length(od.SimInLineTime);
            AlightRate1(j,i)=AlightRate1(j,i)+p.number;
        end  
    end    
end
nn=0;
LineO=zeros(ID*ID,1);
LineD=zeros(ID*ID,1);
LineOO=strings(ID*ID,1);
LineDD=strings(ID*ID,1);
for i=1:ID
    for j=1:ID
        nn=nn+1;
%         kk=find(ID.SHNZ==Line1.From(i,1));
%         LineO(nn,1)=ID.VarName1(kk);
%         LineOO(nn,1)=ID.VarName2(kk);
%         kk2=find(ID.SHNZ==Line1.From(j,1));
%         LineD(nn,1)=ID.VarName1(kk2);
%         LineDD(nn,1)=ID.VarName2(kk2);
          LineO(nn,1)=Line17OD(Line17OD.O_L_ID==kkk(i),:).O_L_ID(i);
          LineOO(nn,1)=Line17OD(Line17OD.O_L_ID==kkk(i),:).O_L_Name(i);
          LineD(nn,1)=Line17OD(Line17OD.O_L_ID==kkk(j),:).O_L_ID(j);
          LineDD(nn,1)=Line17OD(Line17OD.O_L_ID==kkk(j),:).O_L_Name(j);
    end
end


