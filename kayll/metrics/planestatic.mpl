Ndim_ := 4:
x1_ := t:
x2_ := z:
x3_ := x:
x4_ := y:
sig_ := 2:
complex_ := {}:
g11_ := -exp(2*U(z)):
g22_ := 1:
g33_ := exp(2*W(z)):
g44_ := exp(2*W(z)):
constraint_:=[W(z)=int((-int((diff(U(z),`$`(z,2))+diff(U(z),z)^2)*exp(-U(z)),z)+_C1)*exp(U(z)),z)]:
