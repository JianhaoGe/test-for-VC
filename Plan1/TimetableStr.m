AA=[];
for i=1:72
    for j=1:27
        AA(2*j-1,i)=Arrival5(i,j);
        AA(2*j,i)=Departure5(i,j);
    end
end
B=ones(54,72);
BB=string(B);
for i=1:54
    for j=1:72
        h=fix(AA(i,j)/3600);
        min=fix((AA(i,j)-h*3600)/60);
        second=mod(AA(i,j),60);
        if h<10 && min<10 && second<10
            BB(i,j)=string(['0',num2str(h),':','0',num2str(min),':','0',num2str(second)]);
        end
        if h<10 && min>=10 && second<10
            BB(i,j)=string(['0',num2str(h),':',num2str(min),':','0',num2str(second)]);
        end
        if h<10 && min>=10 && second>=10
            BB(i,j)=string(['0',num2str(h),':',num2str(min),':',num2str(second)]);
        end
        if h<10 && min<10 && second>=10
            BB(i,j)=string(['0',num2str(h),':','0',num2str(min),':',num2str(second)]);
        end
        if h>=10 && min<10 && second<10
            BB(i,j)=string([num2str(h),':','0',num2str(min),':','0',num2str(second)]);
        end
        if h>=10 && min>=10 && second<10
            BB(i,j)=string([num2str(h),':',num2str(min),':','0',num2str(second)]);
        end
        if h>=10 && min>=10 && second>=10
            BB(i,j)=string([num2str(h),':',num2str(min),':',num2str(second)]);
        end
        if h>=10 && min<10 && second>=10
            BB(i,j)=string([num2str(h),':','0',num2str(min),':',num2str(second)]);
        end
    end
end