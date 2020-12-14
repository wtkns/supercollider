OSCdef.newMatching(\synthMsg,
	{|msg, time, addr, recvPort |
		var dict = Dictionary.newFrom(msg.drop(1));
		var inst = dict.removeAt(\instrument);
		var busnum = ~addrBook.me.effectBank.busIndex(dict[\outBus]);
		dict.add(\outBus -> busnum);
		Synth.head(~synthGroup, inst, dict.getPairs);
}, "/synthMsg"); // path matching


// Testing functions

OSCdef.newMatching(\testMsg,
	{|msg, time, addr, recvPort |
		addr.sendMsg("/testReply");

}, "/testMsg"); // path matching

OSCdef.newMatching(\testReply,
	{|msg, time, addr, recvPort |
		"Successful messaging test reply received from \\".post;
		(~addrBook.findname(addr)).postln;
}, "/testReply"); // path matching

//audio test
OSCdef.newMatching(\testAudio,
	{|msg, time, addr, recvPort |
		(~addrBook.findname(addr)).postln;
		~testTone = Synth.head(~synthGroup, \saw,
			[\freq, msg.at(1).midicps, \pan, -1, \dur, 5.0, \outBus, ~masterOut]);
		~testTone = Synth.head(~synthGroup, \saw,
			[\freq, msg.at(2).midicps, \pan, 1, \dur, 5.0, \outBus, ~masterOut]);
}, "/testAudio"); // path matching




// CRUD Effect busses//

// Create new effects bus
OSCdef.newMatching(\addEffectOSC,
	{|msg, time, addr, recvPort |
		~addrBook.me.effectBank.addEffect(msg[1].asSymbol, msg[2]);
}, "/addEffectOSC"); // path matching

// Delete
// request to free an effect bus
OSCdef.newMatching(\freeEffectOSC,
	{|msg, time, addr, recvPort |
		~addrBook.me.effectBank.freeEffect(msg[1].asSymbol);
}, "/freeEffectOSC"); // path matching

// // receive, unpack, and update effectList
OSCdef.newMatching(\updateEffectListOSC,
	{|msg, time, addr, recvPort |
		var name =(~addrBook.findname(addr));
		var newMsg = Dictionary.newFrom(msg.drop(1));
		~addrBook.at(name).effectList.dict=newMsg;
}, "/updateEffectListOSC");



// request to set effect bus
OSCdef.newMatching(\setEffectOSC,
	{|msg, time, addr, recvPort |
		~addrBook.me.effectBank.setEffect(msg[1].asSymbol, msg[2], msg[3]);
}, "/setEffectOSC"); // path matching

// Request
// //request to GET effect bus control values
// OSCdef.newMatching(\effectGet,
// 	{|msg, time, addr, recvPort |
// 		//		~addrBook.me.effectSet(msg[1].asSymbol, msg[2], msg[3]);
// }, "/effectGet"); // path matching

// Get Bundle and send EffectList Update
// OSCdef.newMatching(\fetchEffectList,
// 	{|msg, time, addr, recvPort |
// 		var reply=List.new;
// 		~addrBook.me.effectBank.dict.keysValuesDo({|key, value|
// 			reply.add(key);
// 			reply.add(value[0].index);
// 		});
// 		addr.sendMsg("/updateEffectList", *reply);
// 		"sending update reply".postln;
// 		reply.postln;
// }, "/fetchEffectList");
//

