//set up window for display of network peers, and chat
~peers = Window("Mesh Collaborative").front;
~peers.alwaysOnTop = true;
~peers.layout = VLayout.new.add(~listView = ListView.new, 1, \topleft);

//Set up the address book
~addrBook = AddrBook.new;
~addrBook.addDependant({|addrBook, what, who|
{~listView.items = addrBook.peers.collectAs({|peer|
peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
}, Array)}.defer;
});

~addrBook.addMe("hostname".unixCmdGetStdOut.split($.)[0].replace("\n", "");); // add this machine

//Is this the VPN?
if (~streisand.class == NMLNetAddrMP, {
	"using streisand broadcast address".postln;
	~hail = Hail(~addrBook, 1, broadcastAddr: ~streisand);
}, {
	"using default broadcast address".postln;
	~hail = Hail(~addrBook);
});
~me = ~addrBook.me;

// assumes ~addrBook contains the appropriate Peers
~synthDescRel = SynthDescRelay(~addrBook);

// now adds an action for new descs
~synthDescRel.addDependant({|descRelay, what, desc, defcode|
    "Check out this new def!!\n\n%\n".format(defcode).postln;
});

//Setup chat
~chatter = Chatter(~addrBook);
// Add chat to the window
~peers.layout.add(~textView = TextView(), 3);
//Configure the chat textView
~textView.background_(Color.black);
~textView.editable_(false);
~peers.layout.add(~textField = TextField());
~textField.action_({|v| ~chatter.send(v.string); v.string = "" });
// to get updates, just add a dependant
~chatter.addDependant({|chatter, what, who, chat|
    {
		var whoHue, whoSize, whoString;
		//set the color of the sender
		whoString = who.asString;
		whoSize = whoString.size;
		whoHue = who.hash.wrap(0, 1000) * 0.001;
		~textView.setString(who.asString ++ "\n", ~textView.string.size, 0);
		~textView.setFont(Font("Courier", 12, false), ~textView.selectionStart - who.asString.size - 1, who.asString.size);
		~textView.setStringColor(Color.hsv(whoHue, 0.36, 0.84), ~textView.selectionStart - who.asString.size - 1, who.asString.size);

		~textView.setString(chat.asString ++ "\n", ~textView.string.size, 0);
		~textView.setFont(Font("Menlo", 14, true),~textView.selectionStart - chat.asString.size -1, chat.asString.size);
		~textView.setStringColor(Color.white, ~textView.selectionStart - chat.asString.size - 1, chat.asString.size);
		~textView.select(~textView.string.size, 0);
	}.defer;
});

// make a shared relay
~codeRelay = CodeRelay(~addrBook);
// only send working code to peers
~codeRelay.onlyWorkingCode_(true);
// start History and make its gui for testing
History.start.localOff;
History.makeWin(20@20);
// code relay now sends to History window:
~codeRelay.addHistory;

if(~enableRemoteCodeExecution == true, {
"Remote code execution enabled. Will not interpret code from you twice".postcln;
// Enables executing code from all peers in the addressBook.
~codeRelay.addDependant({|codeRelay, what, who, code|
	if(who != ~me.name,
		{code.asString.interpret},
		{/*do nothing*/});
});} ,{"not executing remote code"});
