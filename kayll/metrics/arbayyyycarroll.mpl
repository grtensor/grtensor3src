Ndim_ := 4:
x1_ := T:
x2_ := R:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1/omega(T,R)^2:
g22_ := 1/omega(T,R)^2:
g33_ := sin(R)^2/omega(T,R)^2:
g44_ := sin(R)^2*sin(theta)^2/omega(T,R)^2:
constraint_ := [omega(T,R) = (cos(T)+cos(R))^(2*q+1)/((2*sin(T))^(2*q))]:
Info_ := `Equation H.26, Carroll, Copyright GRTensor.org`:
