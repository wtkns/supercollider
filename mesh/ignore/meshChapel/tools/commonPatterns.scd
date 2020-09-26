Pn(Pseries.new(start: 0, step: 1, length: inf))

Pn(Pseries(0.05, 0.01, 20))


Pgeom.new(start: 0, grow: 1, length: inf)


//AMP
Prand([0.1, 0.2, 0.3, 0.3] * 0.5, inf)
Pexprand(0.001, 0.5)




// Pitch
Pmeanrand(50, 700)
Pwhite(50, 700)

Pshuf([200, 240, 440, 600], inf)
Prand([200, 240, 440, 600], inf)

Pwalk.new([200, 240, 440, 600], stepPattern, directionPattern: 1, startPos: 0)

// pan

Prand([0,1,2,3], inf)
Pshuf([0,1,2,3], inf)
Pmeanrand(-1.0, 1.0, inf)
Pwhite(-1.0, 1.0, inf)
