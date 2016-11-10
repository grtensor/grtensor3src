Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
g12_   :=   c1(r)   :
g22_   :=   -c1(r)^2*(1-2*m(r)/r)   :
g33_   :=   r^2   :
g44_   :=   r^2*sin(theta)^2   :
Info_ := `     Spherical Bondi metric in advanced coordinates (Proc. R. Soc. London A281,39)   `: 
constraint_:=[(diff(c1(r),`$`(r,2)))=(r*diff(c1(r),r)-5*diff(c1(r),r)*m(r)-2*c1(r)*diff(m(r),r)+3*diff(c1(r),r)*r*diff(m(r),r)+c1(r)*diff(m(r),`$`(r,2))*r)/r/(r-2*m(r))]:
