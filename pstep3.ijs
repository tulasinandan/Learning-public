load 'trig'
load 'plot'

NB. Cross Product definition copied from:
NB. https://code.jsoftware.com/wiki/Essays/Complete_Tensor
CT    =: C.!.2 @ (#:i.) @ $~
ip    =: +/ .*
cross =: [ ip CT@#@[ ip ]

NB. Electric field
EvalE=: 3 : 0
   'xx yy zz' =. y
   e  =. 1,0,0 NB. E = 0.
)
NB. Magnetic field
EvalB=: 3 : 0
   'xx yy zz' =. y
   b  =. 0,1,0 NB. constant B
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

   T =. bf*qom*0.5*dt                 NB.    T = q*B*dt/(2*m)
   Tsq =: +/*: T                      NB.        |T|**2
   S =. +: T % 1+Tsq                  NB.    S = 2*T/(1+|T|**2)
   
   vminus =. vold   + ef*qom*dt*0.5   NB.   v- = vold + q*E*dt/(2*m)
   vprime =. vminus + vminus cross T  NB.   v' = v-   + v- X T
   vplus  =. vminus + vprime cross S  NB.   v+ = v-   + v' X S
             vplus  + ef*qom*dt*0.5   NB. vnew = v+   + q*E*dt/(2*m)
)

updatepos =: 3 : 0 
'qom rx ry rz vx vy vz dt nt' =. y
pos =. (rx,ry,rz) [ vel =. (vx,vy,vz)
trv =. 1$0.0,.1$rx,.1$ry,.1$rz,.1$vx,.1$vy,.1$vz
tt =. 0.
for_ii. i.nt
   do. echo 'On iteration ',":ii
       ef  =. EvalE pos
       bf  =. EvalB pos
       vel =. Boris qom,vel,ef,bf,dt
       pos =. StepX pos,vel,dt
       tt  =. tt + dt
       trv =. trv, (tt,pos,vel)
   end.
)
NB. 
NB. MAIN PROGRAM, THE ONLY HARD CODED THINGS
NB. ABOVE ARE THE E & B FUNCTIONS.
NB. 
'q m' =: 1 1
'nt dt' =: 1000 0.01
ipos =: 0 0 0
ivel =: 1 0 0

qom =. q % m
ef =. EvalE ipos
bf =. EvalB ipos

vel =. Boris qom,ivel,ef,bf,-0.5*dt
trv =: updatepos qom,ipos,vel,dt,nt
