(

~list1 = Array.fill(5, {|i| "Group 1: Item" ++ i});
~list2 = Array.fill(5, {|i| "Group 2: Item" ++ i});
~list3 = Array.fill(5, {|i| "Group 3: Item" ++ i});


w = IdentityDictionary();
w[\window] = Window.new;
w[\button1] = Button().states_([["Tab 1"]]);
w[\button2] = Button().states_([["Tab 2"]]);
w[\button3] = Button().states_([["Tab 3"]]);

w[\button1].action_({
w[\textview1].visible_(true);
w[\textview2].visible_(false);
w[\textview3].visible_(false);
});

w[\button2].action_({
w[\textview2].visible_(true);
w[\textview1].visible_(false);
w[\textview3].visible_(false);
});

w[\button3].action_({
w[\textview3].visible_(true);
w[\textview1].visible_(false);
w[\textview2].visible_(false);
});

w[\textview1] = ListView().items_(~list1);
w[\textview2] = ListView().items_(~list2);
w[\textview3] = ListView().items_(~list3);
w[\layout] = VLayout(
    HLayout(
        w[\button1],
		w[\button2],
		w[\button3]
	),
	w[\textview1],
	w[\textview2].visible_(false),
	w[\textview3].visible_(false));
)

w[\window].layout = w[\layout];
w[\window].front;

w[\showView1].value








///// from Utopia:
//
//
// ~addrBook.addDependant({|addrBook, what, who|
// 	{~listView.items = addrBook.peers.collectAs({|peer|
// 		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
// 	}, Array)}.defer;
// });
//



