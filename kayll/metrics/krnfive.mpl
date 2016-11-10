Ndim_ :=    5   :
x1_   :=   u   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
x5_ := delta:
complex_ := {}:
g12_   :=   -8*m^2*((2*m)^2-r(u,v)^2)/(4*u*v*r(u,v)^2)   :
g33_   :=   r(u,v)^2   :
g44_   :=   r(u,v)^2*sin(theta)^2   :
g55_ := r(u,v)^2*sin(theta)^2*sin(phi)^2:
constraint_ :=   [diff(r(u,v),u) = -2*m*((2*m)^2-r(u,v)^2)/(2*r(u,v)^2*u), diff(r(u,v),v) =-2*m*((2*m)^2-r(u,v)^2)/(2*r(u,v)^2*v) ]   :
Info_ := `    Null form of Kruskal metric    `: 

