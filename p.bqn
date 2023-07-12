X←{𝕨1⊸⌽⊸×{1⌽𝔽˜-𝔽}𝕩} #Cross Product
##⌾(<˘1⍉⁼⊢) # Row wise operation
CP←{𝕨X ⌾(<˘1⍉⁼⊢)𝕩}
DP←{+˝⍉𝕨×𝕩}
While ← {𝕨{𝕊∘𝔾⍟𝔽𝕩}𝕩@}´
Pilaat ← {⟨d,i,np⟩←𝕩⋄
    ⟨Gnuplot⟩ ← •Import "Gnuplot.bqn"
    p ← d/˜i=np|↕≠d
    plt ← Gnuplot @
    plt.SPlot p‿"w l"
    plt.Show @
}
Boris←{⟨qom,v,e,b,dt⟩←𝕩⋄
  t←0.5×dt×qom×b⋄
  s←2×t÷1+ t DP t ⋄
  vmn ← v+0.5×dt×qom×e⋄
  vpr ← vmn + vmn CP t⋄
  vpl ← vmn + vpr CP s⋄
  vpl + 0.5×dt×qom×e
}
StepX←{⟨r,v,dt⟩←𝕩⋄ r+v×dt}
Update←{⟨qom,r,v,e,b,dt,t,tend⟩←𝕩⋄
  xout←r ⋄ vout ← v
  v↩Boris ⟨qom,v,e,b,-0.5×dt⟩
  While {𝕤⋄t<tend}‿{𝕤
    r↩StepX ⟨r,v,dt⟩
    v↩Boris ⟨qom,v,e,b,dt⟩
    t+↩dt
    xout∾↩r ⋄ vout∾↩v
   }
    ⟨xout,vout⟩
}
⟨np,q,m⟩←⟨3,1.0,1.0⟩        #number particles, charge, mass
⟨dt,t,tend⟩←⟨0.01,0.0,20.0⟩ #timestep, initial t, final t
e ← np‿3 ⥊ ⟨0,0,0⟩          #electric field
b ← np‿3 ⥊ ⟨0,1,0⟩          #magnetic field
r ← np‿3 •rand.Range 0
v ← np‿3 •rand.Range 0
qom←q÷m
⟨xout,vout⟩←Update ⟨qom,r,v,e,b,dt,t,tend⟩
Pilaat ⟨xout,1,np⟩
