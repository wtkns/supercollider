s.queryAllNodes

(

Pbindef(\sinDef,
	\instrument, \partySin,
	\id, 134218929,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur, 1, inf)
).play;

)




Pbindef(\sinDef, \freq, Pdefn(\sindefFreq, 40, inf));


Pbindef(\sinDef, nil)


Pdefn(\sindefFreq, 60, inf);

Pdefn(\sinBindefDur, 0.5, inf)


Pdefn(\sindefFreq).free
Pdefn(\sinBindef).free


Pbindef(\sinDef, \freq, Pdefn(\sindefFreq, Pexprand(100, 2000, inf)));

Pbindef(\sinDef, \amp, Pdefn(\sindefAmp, 0.1, inf));




Pdefn(\sindefFreq, 100, inf);



 Pdefn(\sindefAmp, 0.1, inf));

Pdefn(\sindefFreq, 1000, inf);

Pdefn(\hihatDurBindef1, 1, inf);

Pbindef(\hihatBindef1, \gate, Pdefn(\hihatT_gateBindef1, 1));
Pbindef(\hihatBindef1, \len, Pdefn(\hihatLenBindef1, Pexprand(0.01, 2, inf)));
Pbindef(\hihatBindef1, \lpFreq, Pdefn(\hihatLpFreqBindef1, 100, inf));
Pbindef(\hihatBindef1, \hpFreq, Pdefn(\hihatHpFreqBindef1, 1500, inf));
Pbindef(\hihatBindef1, \out, Pdefn(\hihatOutBindef1, Prand([ 0, 1, 2, 3 ], inf)));
Pbindef(\hihatBindef1, \amp, Pdefn(\hihatAmpBindef1, Pexprand(0.01, 0.2, inf)));

