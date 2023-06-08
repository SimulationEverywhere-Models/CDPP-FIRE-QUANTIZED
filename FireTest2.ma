#include(rules20.inc)
#include(CorseRules.inc)

[top]
components : ForestFire

[ForestFire]
type : cell
dim : (10,10,2)
delay : transport
defaultDelayTime : 1000
border : nowrapped
neighbors : ForestFire(-1,0,0) ForestFire(0,-1,0) ForestFire(1,0,0) 
neighbors : ForestFire(0,1,0)  ForestFire(0,0,0)  ForestFire(0,0,-1) ForestFire(0,0,1) 
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
%Unburned
rule : { #macro(unburned) + #macro(q) } {round (((11.56 * exp( 0.0005187 * ( (0,0,0) + #macro(q) ) ) - 784.7 * exp(-0.01423 * ( (0,0,0) + #macro(q) ) ) )  - (11.56 * exp( 0.0005187 * (0,0,0) ) - 784.7 * exp(-0.01423 * (0,0,0) ) ) ) * 100)} { cellpos(2) = 0 and ( #macro(unburned) > (0,0,0) OR time <= 20 ) AND (0,0,0) < 573 AND (0,0,0) != 209 }

%ti
rule : { time * 0.01 } 1 { cellpos(2) = 1 AND (0,0,-1) >= 573 AND (0,0,0) = 1.0 }

%Burning
rule : { #macro(burning) + #macro(q) } {round (((11.56 * exp( 0.0005187 * ( (0,0,0) + #macro(q) ) ) - 784.7 * exp(-0.01423 * ( (0,0,0) + #macro(q) ) ) )  - (11.56 * exp( 0.0005187 * (0,0,0) ) - 784.7 * exp(-0.01423 * (0,0,0) ) ) ) * 100)} { cellpos(2) = 0 AND ( ( (0,0,0) > #macro(burning) AND (0,0,0) > 333) OR (#macro(burning) > (0,0,0) AND (0,0,0) >= 573) )AND (0,0,0) != 209 }

%Burned
rule : { 209 } 100 { cellpos(2) = 0 AND (0,0,0) > #macro(burning) AND (0,0,0) <= 333 AND (0,0,0) != 209 }

%Stay Burned or constant
rule : {(0,0,0)} 1 {t}
