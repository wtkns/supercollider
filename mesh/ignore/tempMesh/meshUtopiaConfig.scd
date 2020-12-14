(
~win = Window("AdHocSociety").front;
~win.layout = VLayout.new.add(~listView = ListView.new);

~addrBook = AddrBook.new;
// to get updates, just add a dependant
~addrBook.addDependant({|addrBook, what, who|
	{~listView.items = addrBook.peers.collectAs({|peer|
		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
	}, Array)}.defer;
});

~addrBook.addMe; // will automatically add you using your user name
//~addrBook.addMe(\adcxyz); // or specify one

~hail = Hail(~addrBook);

)

~addrBook.names;




////////////////////////
// Beacon Clocks

// this is a decentralised clock, we can have as many as we like on any machines
// we'll make these all the same, but you can have independent ones by specifying different
// OSC paths for them
(
~clock1 = BeaconClock(~addrBook);
~clock2 = BeaconClock(~addrBook);
~clock3 = BeaconClock(~addrBook);
)


// beats and tempi will all be the same
// get your friends to compare on their computers
"Beats1: % Beats2: % Beats3: % Tempo1: % Tempo2: % Tempo3: %\n".postf(~clock1.beats, ~clock2.beats, ~clock3.beats, ~clock1.tempo, ~clock2.tempo, ~clock3.tempo);

// somebody play something
(
a = Pbind(\degree, Pseq((1..3), inf)).play(~clock1);
b = Pbind(\degree, Pseq((4..6), inf)).play(~clock2);
c = Pbind(\degree, Pseq((8..10), inf)).play(~clock3);
)

// now somebody else try these
~clock3.setGlobalTempo(0.1);
~clock2.setGlobalTempo(30, ~clock2.beats + 0.25); // default is change on next whole beat, but we can specify

// accel or decel is also possible
~clock2.fadeTempo(1, 50); // change to 1 beat/sec over 50 beats

////////////////////////
// ServerRegistry syncs info about Servers between the Peers in the supplied AddrBook.
// This can be the simple case of one server per Peer, but arbitrary configs are also possible.

~reg = ServerRegistry(~addrBook);

// Convenience method to add the default server on this machine under my name
~reg.addMyServer;

~reg.keys; // all the keys in the ServerRegistry

/* Create a PeerGroup manager to create and sync groups between users. PeerGroups can be clients, servers, or anything which matches a name to an address.
In this case we want to have groups of servers, so we'll pass the ServerRegistry, but it also works with clients and AddrBook */
~gm = PeerGroupManager(~reg, '/serverGroups');

// make a server group with two randomly selected servers. Form is \groupName, [key1, key2...]
~gm.add(\twoServers, ~reg.keys.asArray.scramble.keep(2)); // make a group

x = Synth(\default, target:~reg.values.choose.postln) // pick a random server
x.free;
// we can use any method that Array understands, since PeerGroup is an Array subclass!
Synth(\default, target:~gm[\twoServers].choose)

// similarly, we can use any list pattern with a PeerGroup, since it is an Array
Pbind(\server, Pseq(~gm[\twoServers], inf), \dur, 0.1).play

Pbind(\server, Pseq(~reg.values, inf), \dur, 0.1, \degree, Pseq((0..9), 1)).play


// AddrBook methods which produce PeerGroups
~addrBook.peers; // a PeerGroup with everybody
~addrBook.others; // a PeerGroup with everybody else
~addrBook.onlinePeers; // a PeerGroup with everybody currently online


////////////////////////
// SynthDescRelay keeps shares SynthDefs between Peers
// we'll get updated each time a new desc is added remotely
// and SynthDescRelay adds the desc to the specified lib (the global on by default)
// (If we use the add method, all known servers will be updated anyway, but this keeps
// out libs in sync)

// everybody run this
~synthDescRel = SynthDescRelay(~addrBook);

// now adds an action for new descs
(
~synthDescRel.addDependant({|descRelay, what, desc, defcode|
	"Check out this new def!!\n\n%\n".format(defcode).postln;
});
)

// now someone make a def
SynthDef(\foo, {|freq = 440, dur = 1, amp = 0.1| Out.ar(0, SinOsc.ar(freq, 0, amp) * Env.sine(dur).kr(2));}).add;

// someone else try to look it up
SynthDescLib.at(\foo);
Synth(\foo);




/// from beaconclocktest.scd
~clock = BeaconClock(~addrBook).permanent_(true);
~clock = TempoClock.new;

Pbind(\freq, rrand(440, 880)).play(~clock, quant: 1);

Pbind(\freq, Pfunc({"beats: % tempo: %\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200) })).play(~clock, quant: 1);

~clock.tempo = 1
~clock.setGlobalTempo(3, 90)
~clock.setGlobalTempo(3);

~clock.fadeTempo(10, 3)

~clock.warpTempo(2, 30)

(
SynthDef(\click, {
	var click;
	click = Impulse.ar(0);
	DetectSilence.ar(click,doneAction:2);
	OffsetOut.ar(0, click * 0.5);
}).add;
)

Pbind(\instrument, \click, \freq, Pfunc({"beats: % tempo: %\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200) })).play(~clock, quant: 1);