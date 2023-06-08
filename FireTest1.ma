#include(rules1.inc)

[top]
components : ForestFire

[ForestFire]
type : cell
dim : (10,10,3)
delay : inertial
defaultDelayTime : 1
border : nowrapped
neighbors : ForestFire(-1,0,1) ForestFire(0,-1,1) ForestFire(1,0,1) 
neighbors : ForestFire(0,1,1)  ForestFire(0,0,0)  ForestFire(0,0,-1) ForestFire(0,0,1) 
neighbors : ForestFire(0,0,-2)
% neighbors : ForestFire(0,0,0) ForestFire(0,0,-1) ForestFire(0,0,1) ForestFire(0,-1,0)
initialValue : 0.0
initialCellsValue : FireTest.val
zone : cst { (0,0,0)..(0,9,0) }  
zone : cst { (1,9,0)..(9,9,0) }
zone : cst { (9,0,0)..(9,8,0) } 
zone : cst { (1,0,0)..(8,0,0) }

localTransition : FireBehavior

[cst]
%Undefined border cells
rule : {(0,0,0)} 1 {undefCount >= 1}
rule : {(0,0,0)} 1 {t}


[FireBehavior]
rule : {273} 0 { (0,0,0) = 273 }

% Time of ignition
rule : { time * 0.01 } 1 { cellpos(2) = 2 AND (0,0,-2) >= 573 AND (0,0,0) = 0.0 }

% Burning Up
rule : {(0,0,0) + #macro(q) } {round (((11.56 * exp( 0.0005187 * ( (0,0,0) + #macro(q) ) ) - 784.7 * exp(-0.01423 * ( (0,0,0) + #macro(q) ) ) )  - (11.56 * exp( 0.0005187 * (0,0,0) ) - 784.7 * exp(-0.01423 * (0,0,0) ) ) ) * 100)} {  ( (0,0,1) = -100) or ( (0,0,1) = -200) or ( (0,0,1) = -300 )  }

% Burndown
% rule : {(0,0,0) - 10 } { ( ( ( -0.052 * ( (0,0,0) - 10 ) ) + 74 ) - ( ( -0.052 * (0,0,0) ) + 74 ) ) * 1000 } { ( (0,0,0) >= 301) and ( (0,0,1) = -400) }
rule : {(0,0,0) - #macro(q) } {round ( #macro(q) * 0.052 * 100 ) } { ( (0,0,1) = -400) }

% Getting Warm State
rule : {-100} 1 {((0,0,-1) >= 301) and ((0,0,-1) <= 474) and ((0,0,0) = 0) }

% Two cells Hot Enough to Warm State
rule : {-200} 1 {((0,0,-1) >= 474) and ( ( (0,0,0) = -100) or ( (0,0,0) = 0 ) ) }

% One cell Hot Enough to Warm State
rule : {-300} 1 {((0,0,-1) >= 650) and ( ((0,0,0) = -200) or ((0,0,0) = 0) ) }

% Decreasing and still burning
rule : {-400} 1 {((0,0,-1) >= 992) and ( (0,0,0) = -300) }

% Burnt out
rule : {-500} 1 {((0,0,-1) <= 333) and ( (0,0,0) = -400 ) }
rule : {273} 1 {(0,0,1) = -500}

% Ignition rules
rule : {301} 1 { cellpos(2) = 0 AND stateCount ( -200 ) >= 2 AND (0,0,0) = 300 }
rule : {301} 1 { cellpos(2) = 0 AND stateCount ( -300 ) >= 1 AND (0,0,0) = 300 }

%Stay Burned or constant
rule : {(0,0,0)} 1 {t}