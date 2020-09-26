s.boot;

(
SynthDef(\buf_grain_test, {arg gate = 1, sndbuf, amp = 1;
    Out.ar(0,
        BufGrain.ar(Impulse.kr(10), 0.2, sndbuf, MouseX.kr(0.5, 8), PinkNoise.kr.range(0, 1), 2,
            EnvGen.kr(
                Env([0, 1, 0], [1, 1], \sin, 1),
                gate,
                levelScale: amp,
                doneAction: 2)
        )
    )
}).add;
)

s.sendMsg(\b_allocRead, z = s.bufferAllocator.alloc(1), Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

s.sendMsg(\s_new, \buf_grain_test, a=s.nextNodeID, 0, 1, \amp, 0.2, \sndbuf, z);
s.sendMsg(\n_set, a, \gate, 0);
s.sendMsg(\b_free, z);