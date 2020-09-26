// utopiatest


Server.default = s = Server.local;

// network window status: .minimize (to hide) or .front (to show)
~win = Window("network").minimize;

~hostname = ("hostname".unixCmdGetStdOut.split($.)[0]).asSymbol;

~hostname.postln;

 ~addrBook = AddrBook.new;

~addrBook.addMe(~hostname); // add this machine
~hail = Hail(~addrBook);
~me=~addrBook.me;


(~addrBook.me).class;

"oscDefs.scd".loadRelative;

~groups = Dictionary.newFrom(List[
	\synthGroup,  ~synthGroup = Group.tail(s),
	\effectGroup,  ~effectGroup = Group.tail(s)
]);


(
//5. AFTER all Peers have joined
// This should create an env variable named for each peer in the AddrBook
~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)

(
// 6.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.addEffect(\reslpf, \rlpf);
~rose.addEffect(\ringModulator, \ringMod);
~rose.addEffect(\ampModulator, \ampMod);
)

// note: to see available effects: ~peer.effectsList;
~rose.effectsList;

// note: if for some reason the effects lists arent updating, have the machine that isn't working run this:
~addrBook.broadcastEffectList;
