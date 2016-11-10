Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -1/(cos(beta)^2/((1-2*u)*cos(w[a]/2-w(r)/2+beta)^2)):
g22_ := 1/(1-8/3*Pi*rho[0]*r^2+8/5*Pi*rho[0]/a^2/T*r^4):
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [w(r) = ln(r^2/a^2/T-5/6+1/6*6^(1/2)*((5*T-3)/u/T^2)^(1/2)*(1-2*u*T*(5-3*r^2/a^2/T)*r^2/a^2/(5*T-3))^(1/2))]:
