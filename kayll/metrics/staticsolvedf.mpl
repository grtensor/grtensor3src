Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
sig_:=2:
g11_   :=   F(r)/(1-2*m(r)/r)  :
g22_   :=   F(r)*r^2   :
g33_   :=   F(r)*r^2*sin(theta)^2   :
g44_   :=   -F(r)*exp(2*Phi(r))   :
constraint_:=[m(r) = factor(simplify((int(1/2*r*exp(int((2*r^2*F(r)*diff(F(r),`$`(r,2))-3*F(r)^2-3*F(r)*diff(F(r),r)*r-3*diff(F(r),r)^2*r^2-3*r*F(r)^2*diff(Phi(r),r)+2*r^2*F(r)^2*diff(Phi(r),`$`(r,2))+2*r^2*F(r)^2*diff(Phi(r),r)^2)/F(r)/r/(r*diff(F(r),r)+F(r)+r*F(r)*diff(Phi(r),r)),r))*(-2*F(r)*diff(F(r),r)-3*diff(F(r),r)^2*r-2*F(r)^2*diff(Phi(r),r)+2*r*F(r)*diff(F(r),`$`(r,2))+2*r*F(r)^2*diff(Phi(r),r)^2+2*r*F(r)^2*diff(Phi(r),`$`(r,2)))/F(r)/(r*diff(F(r),r)+F(r)+r*F(r)*diff(Phi(r),r)),r)+_C1)*exp(int((-2*r^2*F(r)*diff(F(r),`$`(r,2))+3*F(r)^2+3*F(r)*diff(F(r),r)*r+3*diff(F(r),r)^2*r^2+3*r*F(r)^2*diff(Phi(r),r)-2*r^2*F(r)^2*diff(Phi(r),`$`(r,2))-2*r^2*F(r)^2*diff(Phi(r),r)^2)/r/F(r)/(r*diff(F(r),r)+F(r)+r*F(r)*diff(Phi(r),r)),r))))]:
