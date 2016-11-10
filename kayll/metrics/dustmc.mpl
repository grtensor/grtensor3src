Ndim_ := 4:
x1_ := m:
x2_ := theta:
x3_ := phi:
x4_ := t:
sig_ := 2:
complex_ := {}:
g11_ := exp(alpha(m,t)):
g22_ := R(m,t)^2:
g33_ := R(m,t)^2*sin(theta)^2:
g44_ := -1:
constraint_ :=[alpha(m,t)=log(diff(R(m,t),m)^2/(1+2*E(m))), diff(R(r,t),t) = sqrt(2*m/R(m,t)+2*E(m)+Lambda*R(m,t)^2/3)]:
