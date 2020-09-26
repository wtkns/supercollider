s = Server(\mesher, NetAddr("10.1.10.100", 57120));


// define a synthesis engine ... exactly as in the previous example

SynthDef("sine", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).send(s);


// schedule synthesis ... exactly as in the previous example

s.sendMsg("s_new", "sine", n = s.nextNodeID, 0, 1);

p = Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100 ).play

p.stop





// the following example will end after 5 seconds
// or you can stop it sooner with a stop message
(
p = Pfindur(5,
    Pset(\detune,Pwhite(0,1.0) * [0,1,3,7],
        Ppar([
            Pmono(\default, \dur, 0.2, \freq, Pwhite(1,8) * 100 ),
            Pmono(\default, \dur, 0.1, \freq, Pwhite(1,8) * 300)
        ])
    )
).play;
)
p.stop;



// stop the synth (delete it)

s.sendMsg("/n_free", n);