Ndim_ :=    4   :
x1_   :=   Theta   :
x2_   :=   Phi   :
x3_   :=   Psi   :
x4_   :=   T   :
g11_   :=   -(exp(a(T))^2-exp(a(T))^2*Psi^2+Psi^2*exp(b(T))^2)/(Theta-1)/(Theta+1)   :
g12_   :=   Psi*(-(Psi-1)*(Psi+1))^(1/2)*(exp(b(T))-exp(a(T)))*(exp(b(T))+exp(a(T)))   :
g22_   :=   exp(a(T))^2*Psi^2-exp(a(T))^2*Psi^2*Theta^2+exp(b(T))^2-Psi^2*exp(b(T))^2-exp(b(T))^2*Theta^2+exp(b(T))^2*Theta^2*Psi^2+Theta^2*exp(c(T))^2   :
g23_   :=   Theta*exp(c(T))^2/(-(Psi-1)*(Psi+1))^(1/2)   :
g33_   :=   -exp(c(T))^2/(Psi-1)/(Psi+1)   :
g44_   :=   -exp(a(T))^2*exp(b(T))^2*exp(c(T))^2   :
Info_ := `    Mixmaster metric (e.g. MTW Box 30.1, Theta = cos(theta), Psi = sin(psi))    `: 

