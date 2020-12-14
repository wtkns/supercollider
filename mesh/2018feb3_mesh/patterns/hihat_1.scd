(
~hihat_mono=Pmono(
\hihat,
\out, Pdefn(\hihatout_mono, Prand([ 0, 1, 2, 3 ], inf)),

\dur, Pdefn(\hihatdur_mono, Pn(Pseries(0.05, 0.01, 20))),
\len, Pdefn(\hihatlen_mono, nil),

\t_gate, Pdefn(\hihatt_gate_mono, nil),

\lpFreq, Pdefn(\hihatlpFreq_mono, 6000, inf),
\hpFreq, Pdefn(\hihathpFreq_mono, 2500, inf),

\amp, Pdefn(\hihatamp_mono, Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ]))
).play;

)

~hihat_mono.stop

s.queryAllNodes;


~hihat_bindID = NNNNNNN;

(
~hihat_bind=Pbind(
\instrument, \hihat,
\id, ~hihat_bindID,
\type, \set,
\args, #[],
\out, Pdefn(\hihatout_bind, Prand([ 0, 1, 2, 3 ], inf)),

\dur, Pdefn(\hihatdur_bind, Pn(Pseries(0.05, 0.01, 20))),
\len, Pdefn(\hihatlen_bind, nil),

\gate, Pdefn(\hihatt_gate_bind, nil),

\lpFreq, Pdefn(\hihatlpFreq_bind, 6000, inf),
\hpFreq, Pdefn(\hihathpFreq_bind, 2500, inf),

\amp, Pdefn(\hihatamp_bind, Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ]))
).play;


Pdefn(\hihatout_bind, Prand([ 0, 1, 2, 3 ], inf));

Pdefn(\hihatdur_bind, Pn(Pseries(0.05, 0.01, 20)));
Pdefn(\hihatlen_bind, nil);

Pdefn(\hihatt_gate_bind, nil);

Pdefn(\hihatlpFreq_bind, 6000, inf);
Pdefn(\hihathpFreq_bind, 2500, inf);

Pdefn(\hihatamp_bind, Pseq([ Pseries(0, 0.0004, 500), Pn(0.2) ]));
)

~hihat_bind.stop

s.sendMsg(/n_free, ~hihat_monoID);


