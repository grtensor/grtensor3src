Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -r^2/4:
g22_ := 1/((1-k*r^2)):
g33_ := r^2*f(t):
g44_ := r^2*f(t)*sin(theta)^2:
Info_ := `Gutman-Bespalko metric `:
constraint_ := [f(t)=1/8*_C1*(4*exp(2*(t+_C2)/_C1)+4*exp((t+_C2)/_C1)*_C1+_C1^2)*exp(-(t+_C2)/_C1)]:
Archive4_ := `(4.11.7) p178`:
