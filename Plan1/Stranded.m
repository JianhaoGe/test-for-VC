% load('套跑6，滞留最小，当前客流分配结果11.mat')
load('套跑6，滞留最小，超倍客流分配结果11.mat')
Stranded3=sum(Qstranded_line1_left,1);
Stranded3(:,9:end)=Stranded3(:,9:end)+sum(Qstranded_line3_left,1);
Stranded4=sum(Qstranded_line5_left,1);
Stranded3=round(Stranded3);
Stranded4=round(Stranded4);