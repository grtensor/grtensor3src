Ndim_ := 4:
x1_ := xi:
x2_ := theta:
x3_ := phi:
x4_ := t:
sig_ := -2:
complex_ := {}:
g11_ := R^2*K^2*A^4/(K^2*A^4-xi^2*A^4+4*xi^4*K^2):
g22_ := R^2*xi^2:
g33_ := R^2*xi^2*sin(theta)^2:
g44_ := -sin(ln(1/2/A/K/C*((4*K*(K^2*A^4-xi^2*A^4+4*xi^4*K^2)^(1/2)+8*xi^2*K^2-A^4)*C)^(1/2)))^2:
constraint_ := [A=1/3*3^(3/4)*2^(1/4)*(alpha*(5*gamma-3))^(1/4),K= 1/10*10^(1/2)*(alpha*(5*gamma-3))^(1/2)/gamma^(1/2),C= -1/6*(-sqrt(gamma)*sqrt(3)*sqrt(2)*sqrt(alpha*(5*gamma-3))*sqrt(alpha*(alpha-2)*gamma)+5*alpha*gamma^2-6*alpha*gamma)*3^(1/2)*2^(1/2)/alpha/exp(2*arctan(alpha*gamma^(1/2)*(alpha-2)*3^(1/2)*2^(1/2)/(alpha*(alpha-2)*gamma)^(1/2)/(alpha*(5*gamma-3))^(1/2)))/(alpha*(5*gamma-3))^(1/2)/gamma]:
Info_ := `Tolman VII form a (R. Tolman, Phys. Rev., 55, 364 (1939))`:
