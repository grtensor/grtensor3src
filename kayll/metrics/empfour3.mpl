Ndim_ := 4:
x1_ := t:
x2_ := psi:
x3_ := y:
x4_ := phi:
sig_ := 3:
complex_ := {}:
g11_ := -F[x](x)/F[y](y):
g12_ := -F[x](x)/F[y](y)*(nu/xi[1])^(1/2)/A*xi[2]+F[x](x)/F[y](y)*(nu/xi[1])^(1/2)/A*y:
g22_ := -F[x](x)/F[y](y)*nu/xi[1]/A^2*xi[2]^2+2*F[x](x)/F[y](y)*nu/xi[1]/A^2*xi[2]*y-F[x](x)/F[y](y)*nu/xi[1]/A^2*y^2-1/A^2/(x-y)^2*F[x](x)*G[y](y):
g33_ := -1/A^2/(x-y)^2*F[x](x)*F[y](y)/G[y](y):
g44_ := 1/A^2/(x-y)^2*F[y](y)^2*G[x](x)/F[x](x):
constraint_:=[F[x](x)=1-x/xi[1],F[y](y)=1-y/xi[1],G[x](x)=nu*x^3-x^2+1,G[y](y)=nu*y^3-y^2+1]:
