Ndim_ :=    4   :
x1_   :=   u   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
g12_   :=   -f(u,v)*8*m^2*(2*m-r(u,v))/(u*v*r(u,v))   :
g33_   :=   f(u,v)*r(u,v)^2   :
g44_   :=   f(u,v)*r(u,v)^2*sin(theta)^2   :
constraint_ :=   [diff(r(u,v),u) = -2*m*(2*m-r(u,v))/(r(u,v)*u), diff(r(u,v),v) =-2*m*(2*m-r(u,v))/(r(u,v)*v) ]   :
Info_ := `    Null form of Kruskal metric    `: 

