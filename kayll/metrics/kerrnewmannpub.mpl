Ndim_ :=    4   :
x1_   :=   t   :
x2_   :=   r   :
x3_   :=   theta   :
x4_   :=   phi   :
eta12_   :=   1   :
eta34_   :=   -1   :
sig_:=-2:
complex_ := {}:
b11_   :=   (r^2+a^2)/(r^2-2*M*r+a^2+Q^2)   :
b12_   :=   1   :
b14_   :=   a/(r^2-2*M*r+a^2+Q^2)   :
b21_   :=   1/2*(r^2+a^2)/(r^2+a^2*cos(theta)^2)   :
b22_   :=   -1/2*(r^2-2*M*r+a^2+Q^2)/(r^2+a^2*cos(theta)^2)   :
b24_   :=   1/2*a/(r^2+a^2*cos(theta)^2)   :
b31_   :=   1/2*(I*sin(theta)*r+sin(theta)*a*cos(theta))*a*2^(1/2)/(r^2+a^2*cos(theta)^2)   :
b33_   :=   1/2*(r-I*a*cos(theta))*2^(1/2)/(r^2+a^2*cos(theta)^2)   :
b34_   :=   1/2*I*(r-I*a*cos(theta))/sin(theta)*2^(1/2)/(r^2+a^2*cos(theta)^2):
b41_   :=   1/2*(-I*sin(theta)*r+sin(theta)*a*cos(theta))*a*2^(1/2)/(r^2+a^2*cos(theta)^2)   :
b43_   :=   1/2*(r+I*a*cos(theta))*2^(1/2)/(r^2+a^2*cos(theta)^2)   :
b44_   :=   -1/2*I*(r+I*a*cos(theta))/sin(theta)*2^(1/2)/(r^2+a^2*cos(theta)^2):
constraint_ := [ ]:
Info_:=`Contravariant NP tetrad for the Kerr Newman metric in Boyer Lindquist coordinates`:
Ref_:=["Newman, jmp, v6, p918, (1965)"]:
Archive1_:=`(19.19) p213`:  