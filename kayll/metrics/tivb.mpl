Ndim_ := 4:
x1_ := xi:
x2_ := theta:
x3_ := phi:
x4_ := t:
sig_ := 2:
complex_ := {}:
g11_ := R^2*alpha*A(xi)/(A(xi)-xi^2)/(alpha-xi^2):
g22_ := R^2*xi^2:
g33_ := R^2*xi^2*sin(theta)^2:
g44_ := -(A(xi)-xi^2)/(alpha-3):
constraint_:=[A(xi)=alpha-3+2*xi^2]:
Info_:=`R. Tolman, Phys. Rev., 55, 364 (1939)`:
