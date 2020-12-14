Pbindef.clear

(
~stringResBindef1 = Pbindef(\stringResBindef1,
\instrument, \stringResJames,
\id, 268436456,
\type, \set,
\args, #[],
\dur, Pdefn(\stringResDurBindef1, Pwhite(2, 5), inf)
).play;
)


Pbindef(\stringResBindef1, \dur, Pdefn(\stringResDurBindef1, Pwhite(0.012, 0.15), inf));
Pbindef(\stringResBindef1, \out, Pdefn(\stringResOutBindef1, Prand([ 0, 1, 2, 3 ], inf)));
Pbindef(\stringResBindef1, \startfreq, Pdefn(\stringResStartfreqBindef1, Pwhite(10, 20), inf));
Pbindef(\stringResBindef1, \endfreq, Pdefn(\stringResEndfreqBindef1, Pwhite(10, 20), inf));
Pbindef(\stringResBindef1, \len, Pdefn(\stringResLenBindef1, Pwhite(10, 20), inf));
Pbindef(\stringResBindef1, \gate, Pdefn(\stringResT_gateBindef1, 0, inf));
Pbindef(\stringResBindef1, \res, Pdefn(\stringResResBindef1, 0.99, inf));
Pbindef(\stringResBindef1, \amp, Pdefn(\stringResAmpBindef1, Pexprand(0.15, 0.25), inf));
Pbindef(\stringResBindef1, \att, Pdefn(\stringResAttBindef1, Pexprand(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \dec, Pdefn(\stringResDecBindef1, Pexprand(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \sus, Pdefn(\stringResSusBindef1, Pwhite(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \attime, Pdefn(\stringResAttimeBindef1, Pwhite(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \dectime, Pdefn(\stringResDectimeBindef1, Pwhite(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \sustime, Pdefn(\stringResSustimeBindef1, Pwhite(0.01, 0.02), inf));
Pbindef(\stringResBindef1, \reltime, Pdefn(\stringResReltimeBindef1, Pwhite(0.01, 0.02), inf));


~stringResBindef1.stop

~stringResBindef1.play

Pbindef(\stringResBindef1, \out, Pdefn(\stringResOutBindef1, Prand([ [0,1,2],[3,1,2],[2,0,3],[2,1,2] ], inf)));


Pbindef(\stringResBindef1, \out, nil);
134218728.asTarget


\out, Pdefn(\stringResOutBindef1, 0, inf),

Pbindef(\stringResBindef1).stop

Pbindef.clear