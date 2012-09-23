RST-Designer
============

                   ------------   To launch the interface run the file RST-Designer.m   ------------



- Compute RST controller given a model of the system and the reference model
- Compute RST controller with a smooth command
- Add integrators
- Choice of the relative and absolute damping conditions
- Choice of the sampling time
- Choice of observator polynomial A0
- Choice of  auxiliary polynomial Pa
- Display several graphics: poles, step response, sensibility...
- Comparison of the last two controllers
- Drag cancellation
- Choice of fix terms

The default parameters are:
  - No integrator
  - No drag cancellation
  - For absolute damping condition, transition state should damp of a factor a=20 in a time ka*Ts with ka=10     (Ts: sampling time)
  - For relative damping condition, transition state should damp of a factor a=535 in N=1 oscillation
  - Spectral factorization of the numerator relative to the damping conditions

By pressing the button 'Compute RST', the following parameters are chosen:
  - No fix term
  - Observatory polynomial A0 and auxiliary polynomial Pa are chosen deadbeat

By pressing the button 'Compute smoot RST', the following parameters are chosen:
  - Fix term Ps= z+1 to reduce the influence of the measurement noise on the system input
  - Poles of A0 and Pa are chosen three times smaller than poles of P the model


This program was written based on the book of Roland Longchamp: "Commande numérique de systèmes dynamiques", 2006
