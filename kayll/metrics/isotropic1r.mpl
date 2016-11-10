Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -1/exp(int(Phi(r),r))^2:
g22_ := exp(int(Phi(r),r))^2*exp(psi(r))^2:
g33_ := exp(int(Phi(r),r))^2*exp(psi(r))^2*r^2:
g44_ :=exp(int(Phi(r),r))^2*exp(psi(r))^2*r^2*sin(theta)^2:
constraint_ := [Phi(r)=sqrt(diff(psi(r),r)/r+2*diff(psi(r),r)^2-diff(psi(r),r,r))]:
