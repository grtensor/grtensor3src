Ndim_ := 4:
x1_ := psi:
x2_ := xi:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ :=-1/(4*cos((psi+xi)/2)^2*cos((psi-xi)/2)^2):
g22_ := 1/(4*cos((psi+xi)/2)^2*cos((psi-xi)/2)^2):
g33_ := r(psi,xi)^2:
g44_ := r(psi,xi)^2*sin(theta)^2:
constraint_ := [r(psi,xi)=(tan((psi+xi)/2)-tan((psi-xi)/2))/2]:
Info_ := `Equation 34.2c, Misner-Thorne-Wheeler, Copyright GRTensor.org`:


