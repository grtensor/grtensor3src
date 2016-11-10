Ndim_ :=    3  :
x1_   :=   u   :
x2_   :=   phi   :
x3_   :=   t   :
g11_   :=   (r^2+u^2)/(a^2-u^2)   :
g22_   :=   (a^2-u^2)/a^2*(r^2+a^2+2*(a^2-u^2)*m*r/(r^2+u^2))   :
g23_   :=   -2*(a^2-u^2)/a*m*r/(r^2+u^2)   :
g33_   :=   -1+2*m*r/(r^2+u^2)   :
Info_:=`The Kerr horizon in Boyer-Lindquist type coordinates (u=a*cos(theta)).`:
constraint_ :=    [u=a*cos(theta), r=m/a+((m/a)^2-1)^(1/2)]:
