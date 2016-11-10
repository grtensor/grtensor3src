Ndim_ :=    4   :
x1_   :=   u   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
g12_   :=   -8*m(u,v)^2*(2*m(u,v)-r(u,v))/(u*v*r(u,v))   :
g33_   :=   r(u,v)^2   :
g44_   :=   r(u,v)^2*sin(theta)^2   :
constraint_ :=   [diff(r(u,v),u) = -2*m(u,v)*(2*m(u,v)-r(u,v))/(r(u,v)*u), diff(r(u,v),v) =-2*m(u,v)*(2*m(u,v)-r(u,v))/(r(u,v)*v) ]   :
Info_ := `    Null form of generalized Kruskal metric    `: 

