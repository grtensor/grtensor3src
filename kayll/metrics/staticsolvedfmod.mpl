Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   F(r)/(1-2*m(r)/r)  :
g22_   :=   F(r)*r^2   :
g33_   :=   F(r)*r^2*sin(theta)^2   :
g44_   :=   -F(r)*exp(2*Phi(r))   :
constraint_:=[m(r) = (int(b(r)*exp(int(a(r),r)),r)+_C1)/(exp(int(a(r),r)))]:
