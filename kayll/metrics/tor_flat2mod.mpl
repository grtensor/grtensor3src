#this file is for a maybe flat toroidal system
#signature +2
Ndim_ := 4:
x1_ := t:
x2_ := eta:
x3_ := phi:
x4_ := theta:
B(eta,theta) := (cosh(eta) -cos(theta)) :
g11_ :=  -a^2  :
g13_ :=  a^2*sinh(eta)  :
g31_ :=  g13_  :
g22_ :=  b^2/B(eta,theta)^2 :
g33_ :=  a^2*sinh(eta)^2  :
g44_ :=  a^2/B(eta,theta)^2 :
constraint_ := [sinh(eta)^2 = cosh(eta)^2 -1] :   
Info_:=`Flat toroidal metric with x term`:
