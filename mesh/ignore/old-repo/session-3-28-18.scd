// next week:

// multiple pbinds for multiple clocks longer arc of one parameter than another

// envelope/gate/trigger





// uncomment the following for basic mesh
~mesh_utopiaPath="/Users/james/git/jhuston/mesh_utopia/setup_utopia.scd";
~synthDefLibraryPath="/Users/james/git/adadu/2018feb3_mesh/synths/";
~serverName = \mesher;
~remotePort = 57110;
~remoteIP = "192.168.0.19";
~maxLogins = 8;
~serverOptions = ServerOptions.new;
~serverOptions.maxLogins = ~maxLogins;
~mesh_utopiaPath.load;
~netAddr = NetAddr(~remoteIP, ~remotePort);//
Server.default = Server.remote(~serverName, ~netAddr, ~serverOptions);



s.boot

SynthDef(\partySin, {|out = 0,
    cps = 200,
    vol = 0.25,
    pos = 0,
    vol_lag = 0.01,
    cps_lag = 0.01|
    var sig = SinOsc.ar(cps.lag(cps_lag)) * vol.lag(vol_lag);
    Out.ar(out, Pan2.ar(sig, pos));
}).add();

Pbindef(\sinDef).clear

Pdefn.removeAll

Pbindef.removeAll


Pbindef(\sinDef).clear
Pbindef(\sinDef).stop



s.queryAllNodes






Pdefn(\sinBindefDur, Pseq([1, 0.5, 0.75, ], inf));

Pdefn(\sinBindefCps, Pseq([0, 0.25, 0.1], inf));

Pdefn(\sinBindefVol, Pseq([0, 0.25, 0.1], inf))

Synth(\partySin)


s.queryAllNodes





// Set the nodeId for the synth:

~party_bindID = 134218733;

~party_node = ~party_bindID.asTarget;


(
Pbindef(\sinDef,
	\instrument, \inputSummer,
	\id, ~party_bindID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur, Pshuf([0.5, 0.5, 0.5, 0.5], inf)/5),
	\in4, Pdefn(\sinBindefCps, Pbrown(-20, -1000, 5, inf))
).play;
)



(
Pbindef(\sinDef2,
	\instrument, \partySin,
	\id, ~party_bindID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur2, Pseq([10], inf)),
	\cps, Pdefn(\sinBindefCps2, Pwhite(60, 200, inf))
).play;
)

Pdefn(\sinBindefDur2, Pseq([5,1,5,2], inf))

Pdefn(\sinBindefDur, Pwhite(0.5, 5, inf));


	\vol, Pdefn(\sinBindefVol, Pseq([0.1], inf)),




(
Pbindef(\sinDef,
	\instrument, \partySin,
	\id, ~party_bindID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur, Pseq([1], inf)),
	\vol, Pdefn(\sinBindefVol, Pseq([0.1], inf)),
	\cps, Pdefn(\sinBindefCps, Pseq([100, 200], inf))
).play;
)



///
~party_node.set(\vol, 0.2);
~party_node.set(\cps, 1190);
~party_node.set(\pos, 1);
~party_node.set(\cps_lag, 0.5);
~party_node.set(\vol_lag, 0.5);
~party_node.set(\cps_lag, 5);


~party_node.free


67109865.

\vol_lag, Pdefn(\sinBindefDur),
	\cps_lag, Pdefn(\sinBindefDur),
	\vol, Pdefn(\sinBindefVol, Pseq([0, 0.25, 0.1, 0], inf)),



Pbindef(\sinDef).clear





201327592.asTarget.free

Event.new().asStream.next.dump

Synth(\partySin).collect{|event| ~nodeID = event[\id]; event}.play;



~nodeID = 201327595.asTarget;


~nodeID.free;


Pbindef(\sinDef).clear;
Pbindef(\sinDef2).clear;

(

Pbindef(\sinDef,
	\instrument, \partySin,
	\id, ~nodeID,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur, 1, inf)
).play;

)

Pbindef(\sinDef).stop


67109865.asTarget.free;

s.queryAllNodes;


Pdefn(\sinBindefDur, 0.5, inf);

Pdefn(\sindefCps, Pshuf([100,200,300], inf);


	(
		Pbindef(\sinDef2,
			\instrument, \partySin,
			\id, ~nodeID,
			\type, \set,
			\args, #[],
			\dur, Pdefn(\sinBindefDur2, 5, inf)
		).play;
	)


Pdefn(\sinBindefDur2, Pseq([0.5, 0.25, 1.0], inf))

Pbindef(\sinDef, \cps, Pdefn(\sindefCps, 100, inf));
Pbindef(\sinDef, \vol_lag, Pdefn(\sindefVolLag, 10, inf));
Pbindef(\sinDef, \cps_lag, Pdefn(\sindefCPSLag, 0.5, inf));
Pbindef(\sinDef, \pos, Pdefn(\sindefPos, 1, inf));

Pbindef(\sinDef, \vol, Pdefn(\sindefVol, Pseq([0, 0.5, 0.25], inf));

		Pbindef(\sinDef2, \cps_lag, Pdefn(\sindefCPSLag, 5, inf));




Pbindef(\sinDef, nil)


Pdefn(\sindefCps, 0, inf);

Pdefn(\sinBindefDur, 10, inf)


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

