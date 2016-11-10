Ndim_ := 5:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
x5_ := w:
sig_ := 5:
complex_ := {}:
g11_ := -(((1-m/r)/(1+m/r))^(1/alpha))^2:
g22_ := a*(-4*m^3/r^3/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2-m^4/r^4/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+2*m^5/r^5/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+m^6/r^6/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+1/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m/r-1/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m^2/r^2):
g33_ := a*(-4*m^3/r/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2-m^4/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2/r^2+2*m^5/r^3/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+m^6/r^4/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+r^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+2*r/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m-1/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m^2):
g44_ := a*(-4*m^3/r*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2-m^4*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2/r^2+2*m^5/r^3*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+m^6/r^4*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+r^2*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2+2*r*sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m-sin(theta)^2/(1+m/r)^2/(((1-m/r)/(1+m/r))^(beta/alpha))^2/(((1-m/r)/(1+m/r))^(1/alpha))^2*m^2):
g55_ := (((1-m/r)/(1+m/r))^(beta/alpha))^2:
constraint_:=[alpha^2=beta^2+beta+1]:
