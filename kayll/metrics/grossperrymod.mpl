Ndim_ := 5:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
x5_ := w:
sig_ := 5:
complex_ := {}:
g11_ := -(((1-m/r)/(1+m/r))^(1/alpha))^2:
g22_ := (r-m)^2*(r+m)^2*a/(((r-m)/(r+m))^(1/alpha))^2/r^4/(((r-m)/(r+m))^(beta/alpha))^2:
g33_ := (r-m)^2*(r+m)^2*a/(((r-m)/(r+m))^(1/alpha))^2/(((r-m)/(r+m))^(beta/alpha))^2/r^2:
g44_ := (r-m)^2*(r+m)^2*sin(theta)^2*a/(((r-m)/(r+m))^(1/alpha))^2/(((r-m)/(r+m))^(beta/alpha))^2/r^2:
g55_ := (((1-m/r)/(1+m/r))^(beta/alpha))^2:
constraint_:=[alpha^2=beta^2+beta+1]:
