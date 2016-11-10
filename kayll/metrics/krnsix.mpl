Ndim_ :=    6   :
x1_   :=   u   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_ := delta:
x6_ := eta:
complex_ := {}:
g12_   :=   -8*m^2*((2*m)^3-r(u,v)^3)/(u*v*r(u,v)^3)   :
g33_   :=   r(u,v)^2   :
g44_   :=   r(u,v)^2*sin(theta)^2   :
g55_ := r(u,v)^2*sin(theta)^2*sin(phi)^2:
g66_ := r(u,v)^2*sin(theta)^2*sin(phi)^2*sin(delta)^2:
constraint_ :=   [diff(r(u,v),u) = -2*m*((2*m)^3-r(u,v)^3)/(r(u,v)^3*u), diff(r(u,v),v) =-2*m*((2*m)^3-r(u,v)^3)/(r(u,v)^3*v) ]   :
Info_ := `    Null form of Kruskal metric    `: 

