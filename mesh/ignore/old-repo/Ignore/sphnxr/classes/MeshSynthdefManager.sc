MeshSynthdefManager {
	var synthdefLibrary, <>synthdefLibWin, <>synthdefLibView;

	*new {|host| ^super.new.init(host) }

	init {|host|
		("Initializing Synthdef Manager:").postln;

		synthdefLibrary = MeshSynthdefLibrary.new();
		this.addHost(host);
		this.loadLocalSynthdefLibrary(host);
		this.newSynthdefLibWindow;
		("  Synthdef Library Window Created: Success").postln;
	}

	addHost {|host|
		synthdefLibrary.put(host, Set.new());
		^"Synthdef Host added".postln;
	}

	loadLocalSynthdefLibrary{|host|
		var folder = "../synthLib/*".resolveRelative.pathMatch;
		"  Loading Synths".postln;
		//for each file in the synthdef folder
		folder.collect {|file|
			var synth;
			synth = file.load; // load the synthdef
			this.addSynthdef(host, synth); // add the synth
			($\t ++ file ++ "  loaded").postln
		};
		("  Synth Library Loaded: Success").postln;
	}

	addSynthdef {|host, synth|
		synthdefLibrary.includesKey(host).not and: {^"no such host".postln};
		synthdefLibrary[host].includes(synth) and: {^"synth already exists".postln};
		^synthdefLibrary[host].add(synth);
	}

	exists {|host, synth|
		synth.isNil and: {^synthdefLibrary.includesKey(host)};
		synthdefLibrary.includesKey(host).not and: {^"no such host".postln};
		^ synthdefLibrary[host].includes(synth);
	}

	hosts { ^synthdefLibrary.keys}

	synths {|host| ^synthdefLibrary[host].collect({|item| item.name})}

	synthdef {|host, name| ^synthdefLibrary[host].do(
		{|item| item.name == name and: {^ item}})}

	controls {|host, name|
		^ this.synthdef(host,name).allControlNames.collect(_.name)}

	newSynthdefLibWindow {
		synthdefLibWin = Window("Synths Library").minimize;
		synthdefLibWin.alwaysOnTop=true;
		synthdefLibWin.layout = VLayout.new.add(
			synthdefLibView = ListView.new);
		this.updateSynthDefLibWindow;
	}

	updateSynthDefLibWindow{
		var items = Array.new();
		synthdefLibrary.keysValuesDo{|host, synthList|
			items = items.add(host ++ synthList.collect({arg item; item.name}))};
		synthdefLibView.items =	items;
	}

	toggleSynthdefLibWindow {
		if (synthdefLibWin.visible==true)
		{synthdefLibWin.visible=false}
		{synthdefLibWin.visible=true;
			this.updateSynthDefLibWindow}
	}

}


MeshSynthdefLibrary : IdentityDictionary {}

