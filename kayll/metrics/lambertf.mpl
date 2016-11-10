Ndim_ := 4:
x1_ := R:
x2_ := theta:
x3_ := phi:
x4_ := t:
sig_ := 2:
complex_ := {}:
g11_ := (1+2*f(R))^(3/2)/((1+2*f(R))^(1/2)+2*R^2*2^(1/2)*Pi^(1/2)*exp(1/2)*erf(1/2*(4*f(R)+2)^(1/2))-2*R^2*_C1)/(1+f(R))^2:
g22_ := R^2:
g33_ := R^2*sin(theta)^2:
g44_ := -2*R^2/f(R):
constraint_ := [f(R) = LambertW(2*R^2)]:
