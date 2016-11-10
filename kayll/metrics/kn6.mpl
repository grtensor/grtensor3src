Ndim_ :=    4   :
x1_   :=   u   :
x2_   :=   r   :
x3_   :=   theta   :
x4_   :=   phi   :
g11_   :=   -(r^2-2*m*r+Q^2+a^2-a^2*sin(theta)^2)/(r^2-a^2*sin(theta)^2+a^2)   :
g12_   :=   -1   :
g14_   :=   -(2*m*r-Q^2)*a*sin(theta)^2/(r^2-a^2*sin(theta)^2+a^2)   :
g24_   :=   a*sin(theta)^2   :
g33_   :=   r^2-a^2*sin(theta)^2+a^2   :
g44_   :=   (r^4+2*a^2*r^2-a^2*sin(theta)^2*r^2+2*a^2*sin(theta)^2*m*r-a^4*sin(theta)^2-a^2*sin(theta)^2*Q^2+a^4)*sin(theta)^2/(r^2-a^2*sin(theta)^2+a^2)   :
Info_ := `     Outgoing Eddington-Finkelstein form of Kerr-Newman (e.g. MTW Box 33.2)    `: 

