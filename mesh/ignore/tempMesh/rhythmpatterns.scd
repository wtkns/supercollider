//to play with these examples, make sure the Setup File has been run

//footwork kickdrums
(
p.clock.tempo = 2.4;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(Pseq([3,3,3,5],inf),8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
~k.play;
)

//skittery hi-hats
(
p.clock.tempo = 1.5;
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwrand([0.25,Pseq([0.125],2),0.5,Pseq([0.125/2],4)],[4,1,1,0.5].normalizeSum,inf),\amp,Pwhite(0.2,1));
~h.play;
)

//offset percussion patterns for techno feel behind a basic kick
(
p.clock.tempo = 135/60;
~c = Pbind(\instrument,\bplay,\buf,d["sfx"][6],\dur,Pbjorklund2(Pexprand(2,15).round(1),16,inf,Pwhite(1,5).asStream)/4,\amp,1,\rate,2.2);
~c2 = Pbind(\instrument,\bplay,\buf,d["sfx"][6],\dur,Pbjorklund2(Pexprand(2,15).round(1),16,inf,Pwhite(1,5).asStream)/4,\amp,1,\rate,1.9);
~k = Pbind(\instrument,\bplay,\buf,d["sk"][0],\dur,1,\amp,5);
~c.play;
~c2.play;
~k.play;
)

//snare running forwards and back
(
p.clock.tempo = 150/60;
~sn = Pbind(\instrument,\bplay,\buf,d["s"][4],\dur,Pwhite(1,4)/2,\amp,1,\rate,Prand([1,-1],inf),\pos,Pkey(\rate).linlin(-2,2,0.9,0));
~sn.play;
