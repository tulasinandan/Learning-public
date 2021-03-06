load 'trig'
load 'plot'

NB. Cross Product definition copied from:
NB. https://code.jsoftware.com/wiki/Essays/Complete_Tensor
CT=: C.!.2 @ (#:i.) @ $~
ip   =: +/ .*
cross=: [ ip CT@#@[ ip ]

NB. Electric field
EvalE=: 3 : 0
   'xx yy zz' =. y
   e  =. 0,0,0 NB. E = 0.
)
NB. Magnetic field
EvalB=: 3 : 0
   'xx yy zz' =. y
   b  =. 0,0,1 NB. constant B
)

NB. Particle pusher
NB. Input: x,y,z,vx,vy,vz,dt
StepX =: 3 : 0
  'xx yy zz vx vy vz dt' =. y
  (xx,yy,zz) + (vx,vy,vz) * dt
)
NB. Boris Stepper
NB. Input: q/m,vx,vy,vz,ex,ey,ez,bx,by,bz,dt
Boris=: 3 : 0
   'qom vx vy vz ex ey ez mx my mz dt' =. y
   vold =. (vx,vy,vz) [ ef =. (ex,ey,ez) [ bf =. (mx,my,mz)

   T =. bf*qom*0.5*dt
   Tsq =: +/*: T
   S =. +: T % 1+Tsq
   
   vminus     =. vold + ef*qom*dt*0.5 NB. v- = vold + q*E*dt/(2*m)
   vm_cross_T =. vminus cross T       NB. v- X T
   vprime     =. vminus + vm_cross_T  NB. v' = v- + v- X T
   vp_cross_S =. vprime cross S       NB. v' X S
   vplus      =. vminus + vp_cross_S  NB. v+ = v- + v' X S
   vplus + ef*qom*dt*0.5              NB. vnew = v+ +q*E*dt/(2*m)
)

updatepos =: 3 : 0 
'qom rx ry rz vx vy vz nt' =: y
pos =. (rx,ry,rz) [ vel =. (vx,vy,vz)
for_ii. i.nt
   do. echo 'On iteration ',":ii
       ef  =. EvalE pos
       bf  =. EvalB pos
       vel =. Boris qom,vel,ef,bf,dt
       pos =. StepX pos,vel,dt
       rx =: rx,0{pos
       ry =: ry,1{pos
       rz =: rz,2{pos
       vx =: vx,0{vel
       vy =: vy,1{vel
       vz =: vz,2{vel
end.
)
NB. 
NB. 
NB. 
'q m' =: -1 0.01
'nt dt' =: 1000 0.0001
ipos =: 0 0 0
ivel =: 1 0 0

qom =. q % m
ef =. EvalE ipos
bf =. EvalB ipos

vel =. Boris qom,ivel,ef,bf,-0.5*dt
updatepos qom,ipos,vel,nt
