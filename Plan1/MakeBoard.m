function Qboard_right = MakeBoard(Qwait_left,Cremain_left)
%% Constraint 22 
Qboard_right=min(Qwait_left,Cremain_left(:,1:end-1));
