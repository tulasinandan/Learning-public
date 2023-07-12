load 'trig plot'
 CT =: C.!.2 @ (#:i.) @ $~
 ip =: +/ .*
 x  =: _1*[ ip CT@#@[ ip ] 
NB. Particle pusher
 StepX =: ((0 1 2 {  ]) + 3 4 5 {  ] * _1 {  ])
NB. Boris Stepper 
 Boris=: 3 : 0
    'qm v e b dt' =. y
    T   =. b*qm*0.5*dt       NB.    T = q*B*dt/(2*m)
    Tsq =. +/*: T            NB.        ∑|T|²
    S   =. +: T % 1+Tsq      NB.    S = 2*T/(1+∑|T|²)
    vm  =. v + e*qm*dt*0.5   NB.   v- = vold + q*E*dt/(2*m)
           e*qm*dt*0.5 + (vm + vm x T) x S + vm
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
          pos =. StepX pos,vel,dt
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
