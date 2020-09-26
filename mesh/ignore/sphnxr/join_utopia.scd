
//set up display of network peers

// ~win.layout = VLayout.new.add(~listView = ListView.new);
//
 ~addrBook = AddrBook.new;
// // to get updates, just add a dependant
// ~addrBook.addDependant({|addrBook, what, who|
// 	{~listView.items = addrBook.peers.collectAs({|peer|
// 		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
// 	}, Array)}.defer;
// });

"creating address book".postln;
~addrBook.addMe(~hostname); // add this machine
~hail = Hail(~addrBook);
~me=~addrBook.me;


