// next week:

// multiple pbinds for multiple clocks longer arc of one parameter than another

// envelope/gate/trigger



// uncomment the following for basic mesh
~mesh_utopiaPath="/Users/james/git/jhuston/mesh_utopia/server_session.scd";
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


s.queryAllNodes

SynthDef('partySin', {
	|
	out = 0,
    cps = 200,
    vol = 0.25,
    pos = 0
	|
    var sig = SinOsc.ar(cps) * vol;
    Out.ar(out, Pan2.ar(sig, pos));
}).add



Event.new().asStream.next.dump

Synth(\partySin).play

Pbindef(\sinDef).clear;

(
Pbindef(\sinDef,
	\instrument, \partySin,
	\id, 67109865,
	\type, \set,
	\args, #[],
	\dur, Pdefn(\sinBindefDur, 1, inf)
).play;

)

Pbindef(\sinDef).stop


67109865.asTarget.free;

s.queryAllNodes


Pbindef(\sinDef, \cps, Pdefn(\sindefCps, 2000, inf));
Pbindef(\sinDef, \vol_lag, Pdefn(\sindefVolLag, 10, inf));
Pbindef(\sinDef, \cps_lag, Pdefn(\sindefCPSLag, 10, inf));
Pbindef(\sinDef, \pos, Pdefn(\sindefPos, 1, inf));
Pbindef(\sinDef, \vol, Pdefn(\sindefVol, 0.5, inf));




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

