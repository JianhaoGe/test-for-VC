# test for VC in Plan I
    We provide here the matlab pseudocodes of Plan I in the paper of "Transport Capacity Analysis for Sharing-Corridor Metro Lines under Virtual Coupling".
    The codes can not be run directly. Please fill in some functional modules as needed while understanding the code.

## Functional description for codes:
    Main function solved by the proposed model                            --- Main.m
    Sub functions called by the main function                             --- GetTimeInterval.m; MakeBoard.m; MakeDifferentLineHeadwayConstraints.m; MakeDwelltimeConstraints.m; MakeLink.m; MakeLinkConstraints.m; MakeOnlyArrival.m; MakeRemainCapacityinVehicle.m; MakeRuntimeConstraints.m; MakeSameHeadwayConstraints.m; MakeShareArrival.m; MakeAlight.m; Makeinvehicle.m; Makeinvehicleloop.m; Makestranded.m; Makewait.m
    Sample solution results of the model                                  --- result.mat
    Display the train timetable obtained from the solution of the model   --- Display.m
    Draw a heat map showing the full load rates of trains in each section --- Heatmap.m
    Calculate the average full load rate of trains in all sections        --- AFLR.m
    Calculate the average waiting time of passengers                      --- AWT.m
    Capacity utilization of the train timetable of VC referring to UIC406 --- UIC406.m
    Desensitized data input                                               --- Passenger.mat; Runningtime.mat; Dwelltime.mat


## Instructions of main constraint methods used in the pseudocodes:
    Note: Methods are mostly used to linearize the nonlinear constraints. Without these methods, gurobi solver may fail to solve the nonlinear model.
    
### PCM(Partial constraint method):
    If part of variables in the variable matrix need to be constrained, PCM can be used.
    Example:
    Variable:
    A=binvar(m,n);
    B=sdpvar(m,n);
    
    Objective: 
    If A(i,j)==0, B(i,j)=0; If A(i,j)==1, B(i,j) is not restricted.

    Method:
    M=10^8;
    Bmin=-M*A;
    Bmax=M*A;
    Constraint=[Bmin<=B;
               B<=Bmax;
               ];

### RCM(Range constraint method):
    If we need to determine whether the value of one variable is within the specified range of another two variables, RCM can be used.
    Example:
    Variable:
    A=sdpvar(m,n);
    B=sdpvar(m,n);
    C=sdpvar(m,n);
    arf=binvar(m,n);
    
    Objective: 
    If A(m,n)<=C(m,n)<=B(m,n), arf(m,n)=1; Otherwise, arf(m,n)=0;

    Method:
    M=10^8;
    beta1=binvar(m,n);
    beta2=binvar(m,n);
    for i=1:m
        for j=1:n
            beta1left(i,j)=(C(m,n)-A(m,n))/M;
            beta1right(i,j)=(C(m,n)-A(m,n))/M+1; 
            beta2left(i,j)=(B(m,n)-C(m,n))/M;
            beta2right(i,j)=(B(m,n)-C(m,n))/M+1;
            arfleft(i,j)=(beta1left(i,j)+beta2left(i,j)-1.2)/M;
            arfright(i,j)=(beta1left(i,j)+beta2left(i,j)-1.2)/M+1;
        end
    end
    Constraint=[beta1left<=beta1;
                beta1<=beta1right; %% If C(m,n)>=A(m,n); beta1=1;
                beta2left<=beta2;
                beta2<=beta2right; %% If C(m,n)<=B(m,n); beta2=1;
                arfleft<=arf;
                arf<=arfright; %% If beta1==1 & beta2==1; arf=1;
                ];
                
### PRM(Partial assignment method):
    Based on PCM, if part of variables in the variable matrix needs to be equivalent to the corresponding value of another variable matrix. And others equals 0. It is mainly used for those linearized constraints.
    Example:
    Variable:
    A=binvar(m,n);
    B=sdpvar(m,n);
    C=sdpvar(m,n);
    
    Objective: 
    If A(m,n)==1, C(m,n)=B(m,n); If A(m,n)==0, C(m,n)=0.

    Method:
    M=10^8;
    C=sdpvar(m,n);
    Cleft=-M*A;
    Cright=M*A;
    Z=sdpvar(m,n);
    Zleft=-M*(1-A);
    Zright=M*(1-A);
    for i=1:m
        for j=1:n
            C(m,n)=Z(m,n)+B(m,n); 
        end
    end
    Constraint=[Cleft<=C;
                C<=Cright; 
                Zleft<=Z;
                Z<=Zright; 
                ];
    %% If A(m,n)==1, Z(m,n)=0, C(m,n)=B(m,n)
    %% If A(m,n)==0, C(m,n)=0, Z(m,n)=-B(m,n)
    

    
    
    
    
