load 'trig plot'
NB. Cross Product definition copied from:
NB. https://code.jsoftware.com/wiki/Essays/Complete_Tensor
 CT    =: C.!.2 @ (#:i.) @ $~
 ip    =: +/ .*
NB.
NB. Fix this issue of negative cross product
NB.
 cross =: _1*[ ip CT@#@[ ip ] 
NB. Particle pusher
NB. Input: pos,vel,dt
 StepX =: 3 : 0
   'pos vel dt' =. y
   pos + vel*dt
 )
NB. Boris Stepper 
NB. Input: q/m,v_old,ef,bf,dt
 Boris=: 3 : 0
    'qom vold ef bf dt' =. y
         T =. bf*qom*0.5*dt            NB.    T = q*B*dt/(2*m)
       Tsq =. +/*: T                   NB.        ∑|T|²
         S =. +: T % 1+Tsq             NB.    S = 2*T/(1+∑|T|²)
    vminus =. vold   + ef*qom*dt*0.5   NB.   v- = vold + q*E*dt/(2*m)
    vprime =. vminus + vminus cross T  NB.   v' = v-   + v- X T
     vplus =. vminus + vprime cross S  NB.   v+ = v-   + v' X S
              vplus  + ef*qom*dt*0.5   NB. vnew = v+   + q*E*dt/(2*m)
 )
NB. Loop to update position multiple times
 updatepos =: 3 : 0 
   'qom pos vel ti dt nt' =. y
   trv =. ,:(ti, pos, vel) NB. Output array
   for_ii. i.nt
      do. NB. echo 'On iteration ',":ii
          ef  =. EvalE pos
          bf  =. EvalB pos
          vel =. Boris qom;vel;ef;bf;dt
          pos =. StepX pos;vel;dt
          ti  =. ti + dt
          trv =. trv, (ti,pos,vel)
   end.
 )
NB. 
NB. MAIN PROGRAM, THE ONLY HARD CODED THINGS
NB. ARE THE E & B FUNCTIONS BELOW.
NB. 
   'q m' =: 1 1
 'nt dt' =: 1000 0.01
    ipos =: 0 0 0
    ivel =: 1 0 0
NB. Electric field
 EvalE =: 3 : 0
    'xx yy zz' =. y
    e  =. 1,0,0 NB. E = 0.
 )
NB. Magnetic field
 EvalB=: 3 : 0
    'xx yy zz' =. y
    b  =. 0,1,0 NB. constant B
 )
 
 qom =. q % m
 ef  =. EvalE ipos
 bf  =. EvalB ipos
 vel =. Boris qom;ivel;ef;bf;-0.5*dt
 trv =: updatepos qom;ipos;vel;0.0;dt;nt
