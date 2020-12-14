(
~pulse_mono=Pmono(
\pulse,
\out, Pdefn(\pulseout_mono, Prand([ 0, 1, 2, 3 ], inf)),
\dur, Pdefn(\pulsedur_mono, Prand([ Pn(5, 20), Pgeom(2, 1.1, 20), 4, Pgeom(1.345, 0.909, 20), Pn(1, 3) ], inf)),
\len, Pdefn(\pulselen_mono, 0.5, inf),
\gate, Pdefn(\pulset_gate_mono, nil),
\freq, Pdefn(\pulsefreq_mono, 80, inf),
\mod1, Pdefn(\pulsemod1_mono, Pn(Pseries(0.01, 0.01, 99))),
\mod2, Pdefn(\pulsemod2_mono, Pn(Pseries(0.99, -0.01, 99))),
\int, Pdefn(\pulseint_mono, Prand([ Pgeom(0.4, 1.3, 19), Pgeom(0.5, 1.1, 19), Pgeom(4, 0.8, 19), Pseq([ Pgeom(5, 0.83, 10), Pgeom(4, 0.9, 9) ]), Pseq([ Pseries(0.5, 0.5, 10), Pseries(0.1, 0.6, 9) ]) ], inf)),
\att, Pdefn(\pulseatt_mono, Pwrand([ 0.05, 0.95, 'rest' ], [ 0.05, 0.9, 0.05 ], inf)),
\amp, Pdefn(\pulseamp_mono, 0.25, inf),
).play;

)

~pulse_mono.stop

s.queryAllNodes;


~pulse_bindID = NNNNNNN;

(
~pulse_bind=Pbind(
\instrument, \pulse,
\id, ~pulse_bindID,
\type, \set,
\args, #[],
\out, Pdefn(\pulseout_bind, Prand([ 0, 1, 2, 3 ], inf)),

\dur, Pdefn(\pulsedur_bind, Prand([ Pn(5, 20), Pgeom(2, 1.1, 20), 4, Pgeom(1.345, 0.909, 20), Pn(1, 3) ], inf)),
\len, Pdefn(\pulselen_bind, 0.5, inf),

\t_gate, Pdefn(\pulset_gate_bind, 1, inf),

\freq, Pdefn(\pulsefreq_bind, 80, inf),
\mod1, Pdefn(\pulsemod1_bind, Pn(Pseries(0.01, 0.01, 99))),
\mod2, Pdefn(\pulsemod2_bind, Pn(Pseries(0.99, -0.01, 99))),
\int, Pdefn(\pulseint_bind, Prand([ Pgeom(0.4, 1.3, 19), Pgeom(0.5, 1.1, 19), Pgeom(4, 0.8, 19), Pseq([ Pgeom(5, 0.83, 10), Pgeom(4, 0.9, 9) ]), Pseq([ Pseries(0.5, 0.5, 10), Pseries(0.1, 0.6, 9) ]) ], inf)),

\att, Pdefn(\pulseatt_bind, Pwrand([ 0.05, 0.95, 'rest' ], [ 0.05, 0.9, 0.05 ], inf)),
\amp, Pdefn(\pulseamp_bind, 0.25, inf),
).play;


Pdefn(\pulseout_bind, Prand([ 0, 1, 2, 3 ], inf));
Pdefn(\pulsedur_bind, Prand([ Pn(5, 20), Pgeom(2, 1.1, 20), 4, Pgeom(1.345, 0.909, 20), Pn(1, 3) ], inf))
Pdefn(\pulselen_bind, 0.5, inf);

Pdefn(\pulset_gate_bind, 1, inf);

Pdefn(\pulsefreq_bind, 80, inf);
Pdefn(\pulsemod1_bind, Pn(Pseries(0.01, 0.01, 99)));
Pdefn(\pulsemod2_bind, Pn(Pseries(0.99, -0.01, 99)));
Pdefn(\pulseint_bind, Prand([ Pgeom(0.4, 1.3, 19), Pgeom(0.5, 1.1, 19), Pgeom(4, 0.8, 19), Pseq([ Pgeom(5, 0.83, 10), Pgeom(4, 0.9, 9) ]), Pseq([ Pseries(0.5, 0.5, 10), Pseries(0.1, 0.6, 9) ]) ], inf));

Pdefn(\pulseatt_bind, Pwrand([ 0.05, 0.95, 'rest' ], [ 0.05, 0.9, 0.05 ], inf));
Pdefn(\pulseamp_bind, 0.25, inf);
)

~pulse_bind.stop

s.sendMsg(/n_free, ~pulse_monoID);


