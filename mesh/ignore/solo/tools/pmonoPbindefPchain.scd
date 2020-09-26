s.boot

(
p = Pchain(
        PmonoArtic(\default, \dummyArg, 0),
        Pbindef(\mono,
                \degree, Pn(Pseries({ rrand(-3, 3) }, 1, { rrand(5,
10) }), inf), \dur, 0.125,
                \legato, Pseq([Pn(1.01, { rrand(3, 8) }), 0.01], inf)
        )
).play;
)

Pbindef(\mono, \dur, Pwrand([0.125, 0.25], [0.9, 0.1], inf));

p.stop

s.quit; 