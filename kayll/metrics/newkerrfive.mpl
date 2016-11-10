Ndim_ :=    5  :
x1_   :=   r   :
x2_   :=   u   :
x3_   :=   phi   :
x4_   :=   t   :
x5_   :=   l   :
sig_:=4:
g11_   :=   (r^2+u^2)/(r^2-2*m*r+a^2)   :
g22_   :=   (r^2+u^2)/(a^2-u^2)   :
g33_   :=   (a^2-u^2)/a^2*(r^2+a^2+2*(a^2-u^2)*m*r/(r^2+u^2))   :
g34_   :=   -2*(a^2-u^2)/a*m*r/(r^2+u^2)   :
g44_   :=   -1+2*m*r/(r^2+u^2)   :
g55_   :=   F(theta,l)   :
Info_:=`The Kerr metric in Boyer-Lindquist type coordinates (u=a*cos(theta)).`:
constraint_ :=    [u=a*cos(theta)]:
