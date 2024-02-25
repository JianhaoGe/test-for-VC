# test for VC in Plan I
    We provide here the matlab pseudocodes of Plan I in the paper of "Transport Capacity Analysis for Sharing-Corridor Metro Lines under Virtual Coupling".
    The codes can not be run directly. Please fill in some functional modules as needed while understanding the code.

    Functional description for codes:
    Main function solved by the proposed model                            --- Main.m
    Sub functions called by the main function                             --- GetTimeInterval.m; MakeBoard.m; MakeDifferentLineHeadwayConstraints.m; MakeDwelltimeConstraints.m; MakeLink.m; MakeLinkConstraints.m; MakeOnlyArrival.m; MakeRemainCapacityinVehicle.m; MakeRuntimeConstraints.m; MakeSameHeadwayConstraints.m; MakeShareArrival.m; MakeAlight.m; Makeinvehicle.m; Makeinvehicleloop.m; Makestranded.m; Makewait.m
    Sample solution results of the model                                  --- result.mat
    Display the train timetable obtained from the solution of the model   --- Display.m
    Draw a heat map showing the full load rates of trains in each section --- Heatmap.m
    Calculate the average full load rate of trains in all sections        --- AFLR.m
    Calculate the average waiting time of passengers                      --- AWT.m
    Capacity utilization of the train timetable of VC referring to UIC406 --- UIC406.m
    Desensitized data input                                               --- Passenger.mat; Runningtime.mat; Dwelltime.mat
    
    
    
