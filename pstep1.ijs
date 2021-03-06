NB. A fortran77 programmer in guise attempting to learn
NB. better programming skills. The code below updates the 
NB. position and velocity of a particle. Right now it is
NB. a very direct translation, but the hope is to get some
NB. input and learn how to 'j-ify' it. 
NB. 
NB. Follows:
NB.   https://www.particleincell.com/wp-content/uploads/2011/07/ParticleIntegrator.java
NB. 
NB. Very first cut, hasn't been tested at all yet.
load 'trig'
load 'plot'

NB. Return an electric field value for a given position
EvalE=: 3 : 0
   [ 'xx yy zz' =. y
   e  =. 0,0,0 NB. zero electric field as a test case
NB.   e  =. (sin xx), (cos xx), 0 
)
NB. Return a magnetic field value for a given position
EvalB=: 3 : 0
   [ 'xx yy zz' =. y
   b  =. 0,0,1 NB. a constant magnetic field in z direction
NB.   b  =. (cos xx), (sin xx), 0 
)

NB. Particle pusher
NB. Input list is:
NB.       x,y,z,vx,vy,vz,dt
StepX=: 3 : 0
   'xx yy zz vx vy vz dt' =: y
   xxn =. xx+vx*dt
   yyn =. yy+vy*dt
   zzn =. zz+vz*dt
   pos =. xxn,yyn,zzn
)
NB. Boris Stepper
NB. Input list is:
NB.       q/m,vx,vy,vz,ex,ey,ez,bx,by,bz,dt
Boris=: 3 : 0
   'qom vx vy vz ex ey ez mx my mz dt' =: y

   tx  =. qom*mx*0.5*dt
   ty  =. qom*my*0.5*dt
   tz  =. qom*mz*0.5*dt
   tm2 =. tx*tx + ty*ty + tz*tz

   sx  =. 2*tx % (1+tm2)
   sy  =. 2*ty % (1+tm2)
   sz  =. 2*tz % (1+tm2)

   vmix =. vx + qom*ex*dt*0.5
   vmiy =. vy + qom*ey*dt*0.5
   vmiz =. vz + qom*ez*dt*0.5

   vmctx =. vmiy*tz - vmiz*ty 
   vmcty =. vmiz*tx - vmix*tz 
   vmctz =. vmix*ty - vmiy*tx 

   vprx =. vmix+vmctx
   vpry =. vmix+vmcty
   vprz =. vmix+vmctz

   vpcsx =. vpry*sz - vprz*sy 
   vpcsy =. vprz*sx - vprx*sz 
   vpcsz =. vprx*sy - vpry*sx 

   vplx  =. vmix + vpcsx
   vply  =. vmiy + vpcsy
   vplz  =. vmiz + vpcsz

   vxn =. vplx + qom*ex*dt*0.5
   vyn =. vply + qom*ey*dt*0.5
   vzn =. vplz + qom*ez*dt*0.5

   vnew =. vxn, vyn, vzn
)

NB. using =: instead of =. here because I would like to 
NB. have all these variables accessible in the REPL
NB. 
'q m' =: 1 1
qom =: q % m
'nt dt' =: 1000 0.01
'rx ry rz' =: 0 0 0
'vx vy vz' =: 1 0 0

pos =: rx,ry,rz
vel =: vx,vy,vz
ef =: EvalE pos
bf =: EvalB pos

vel =: Boris qom,vel,ef,bf,-0.5*dt
3 : 0
for_ii. i.y
   do. ef  =: EvalE pos
       bf  =: EvalB pos
       vel =: Boris qom,vel,ef,bf,dt
       pos =: StepX pos,vel,dt
       rx =: rx,0{pos
       ry =: ry,1{pos
       rz =: rz,2{pos
       vx =: vx,0{vel
       vy =: vy,1{vel
       vz =: vz,2{vel
end.
] nt
NB.  updatepos nt
NB.  updatepos =: 3 : 0
NB.  for_ii. i.y
NB.     do. ef  =: EvalE pos
NB.         bf  =: EvalB pos
NB.         vel =: Boris qom,vel,ef,bf,dt
NB.         pos =: StepX pos,vel,dt
NB.         rx =: rx,0{pos
NB.         ry =: ry,1{pos
NB.         rz =: rz,2{pos
NB.         vx =: vx,0{vel
NB.         vy =: vy,1{vel
NB.         vz =: vz,2{vel
NB.  end.
NB.  )
NB.  updatepos nt
