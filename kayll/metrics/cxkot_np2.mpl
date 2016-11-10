#this file is for compexified Kottler metric
#L = LAMBDA
Ndim_ := 4:
x1_ := u:
x2_ := r:
x3_ := theta:
x4_ := phi:
k1   := 1/(2^(1/2)) :
Sig(r,theta) := r^2 + a^2*cos(theta)^2 :
Del(r,theta) := r^2-2*m*r+a^2-(L/3)*Sig(r,theta)^2 :
Del2(r,theta) := 2*m*r + (L/3)*Sig(r,theta)^2 :
Om(r,theta) := a*Del2(r,theta)/((r^2 + a^2)*Sig(r,theta) + Del2(r,theta)*a^2*sin(theta)^2) :
#the tetrad metric comp
eta12_   :=   1  :
eta34_   :=   -1 :
#covariant components of l (u,r,theta,phi)
bd11_   :=   1  :
bd12_   :=   0  :
bd14_   :=   -a*sin(theta)^2  :
#covariant components of n (u,r,theta,phi)
bd21_   :=  (1/2)*Del(r,theta)/Sig(r,theta) :
bd22_   :=   1 :
bd24_   :=  -a*sin(theta)^2*bd21_ :
#covariant components of m (u,r,theta,phi)
bd31_   :=   I*k1*a*sin(theta)*(r-I*a*cos(theta))/Sig(r,theta) :
bd32_   :=   0  :
bd33_   :=   -k1*(r-I*a*cos(theta)) :
bd34_   :=   -I*k1*(r^2 + a^2)*sin(theta)*(r-I*a*cos(theta))/Sig(r,theta) :
#covariant components of mbar (u,r,theta,phi)
bd41_   :=   -I*k1*a*sin(theta)*(r+I*a*cos(theta))/Sig(r,theta) :
bd42_   :=   0  :
bd43_   :=   -k1*(r+I*a*cos(theta))  :
bd44_   :=   I*k1*(r^2 + a^2)*sin(theta)*(r+I*a*cos(theta))/Sig(r,theta) :
constraint_ := [cos(theta)^2 + sin(theta)^2 - 1 = 0] :
Info_:=`complexified Kottler - covariant NP tetrad`:
