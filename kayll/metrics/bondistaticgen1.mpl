Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   v   :
x3_   :=   theta   :
x4_   :=   phi   :
g12_   :=   c1(r)   :
g22_   :=   -c2(r)   :
g33_   :=   r^2   :
g44_   :=   r^2*sin(theta)^2   :
Info_ := `     Spherical Bondi metric in advanced coordinates (Proc. R. Soc. London A281,39)   `: 
constraint_:=[c1(r)=1/(-4*Int(1/(exp(Int(2/(2*c2(r)+diff(c2(r),r)*r)*c2(r)/r-diff(c2(r),`$`(r,2))/(2*c2(r)+diff(c2(r),r)*r)*r,r))^2*(2*c2(r)+diff(c2(r),r)*r)*r),r)+_C1)*((-4*Int(1/(exp(Int((2*c2(r)-diff(c2(r),`$`(r,2))*r^2)/r/(2*c2(r)+diff(c2(r),r)*r),r))^2*(2*c2(r)+diff(c2(r),r)*r)*r),r)+_C1)*exp(-4*Int(1/(2*c2(r)+diff(c2(r),r)*r)*c2(r)/r,r)+2*Int(diff(c2(r),`$`(r,2))/(2*c2(r)+diff(c2(r),r)*r)*r,r)))^(1/2)]:
