MeshManager {
	var mesh, <server, <addrBook, hail,
	<>vertexMgr, synthdefMgr, hostname,
	<>peerWin, <>peerView;

	*new {|s|
		^super.new.init(s) }

	init {|s| // accepts server target argument

		"config.scd".loadRelative;

		server=s;
		server.reboot;
		server.waitForBoot({

			("\nServer Started: success").postln;

			mesh = Environment.make({

				~mesh = this;  // shortcut to mesh manager
				addrBook = AddrBook.new;
				this.newPeerWindow;

				hostname = this.hostname;
				("Hostname: " ++ hostname).postln;
				addrBook.addMe(hostname); // add this machine
				~me = addrBook.me;
				~host = hostname;

				// FIX: CHECK FOR NETWORK, IF UNAVAIL SKIP HAIL
				// currently set in config.scd
				(~online==true) and: {hail = Hail(addrBook)};

				("Creating Managers:\n").postln;

				synthdefMgr = MeshSynthdefManager.new(hostname);
				("Synthdef Manager initialized: Success\n").postln;

				vertexMgr = MeshVertexManager.new(hostname);
				("Vertex Manager initialized: Success\n").postln;

				("Managers Created: Success\n").postln;

			});


			// Testing Listener functions
			("Initializing Mesh OSC Listeners:").postln;

			//this.loadOSCDefs;
			("Mesh OSC Listeners initialized: Success").postln;

		});

	}



////  SESSION STUFF

	start {

		if (currentEnvironment === mesh)
		{"\n >>> ALREADY RUNNING!".postln}

		{
			"\n\n\nStarting Mesh".postln;
			mesh.push;
			// this.startClock(~clock);
			// TempoClock.default = ~clock;
			this.listHosts;
			this.nicknames;
			^ "+++ Ready to Collide +++"
		}
	}

	exit {
		if (currentEnvironment === mesh)
		{ "LEAVING ENVIRONMENT".postln;
			currentEnvironment.pop}
	}

	stop { this.exit }

	kill {
		this.exit;
		server.freeAll;
		OSCdef.freeAll;
		server.quit;
		currentEnvironment.removeAt(\meshMgr)
	}

	// Returns hostname from OS
	// FIX: ONLY WORKS ON MAC CURRENTLY!!!
	// need update to check OS and get name accordingly

	hostname{ ^("hostname".unixCmdGetStdOut.split($.)[0]).asSymbol }


	// creates an environment variable for each peer
	// in the Utopia Addr Book
	nicknames {
		//FIX: Set dependency on addrBook peer here somehow?
		// or timed refresh?
		addrBook.names.do({ arg item, i;
			currentEnvironment.put(item.asSymbol,
				addrBook.at(item.asSymbol));
		});
	}

	// outputs peers to post window
	// FIX: maybe adapt to list only ONLINE peers?
	listHosts {
			"\nPeers:".postln;
			addrBook.names.do({|name| (" >"+name).postln});
	}

	listPeers{ ^addrBook.peers}


	startClock {|clock|
		// this use a default name (osc path) for this clock,
		// so it will be the same clock for each participant
		// set as default clock to not have to write ~clock
		// for each pattern
		clock = BeaconClock(addrBook).permanent_(true);
	}

	////////// Synthdef manager:

	listSynths{|host|
		host.isNil and: {host = hostname}; //no Host arg, use this host
		^ synthdefMgr.synths(host)}

	////////// Vertex manager:

	addSynthVertex{|vertexHost, vertexName, synthHost, synthName|
		var synthdef = synthdefMgr.synthdef(synthHost, synthName);
		vertexHost != hostname and: {^"no remote hosts yet"};
		^ vertexMgr.addSynthVertex(hostname, vertexName, synthdef);
	}

	addControlVertex{|vertexhost, vertexname, targethost, targetSynthVertexName|
		"Mesh mgr OK".postln
		^ vertexMgr.addControlVertex(vertexhost, vertexname, targethost, targetSynthVertexName)
	}

	addHost {|host|
		synthdefMgr.addHost(host);
		vertexMgr.addHost(host);
		^ "host added!"
	}

	listVertexHosts{ ^vertexMgr.hosts}

	listSynthHosts{ ^synthdefMgr.hosts}

	removeVertex{|host, vertexname| ^vertexMgr.removeVertex(host, vertexname)}

	groups{ ^vertexMgr.groups}

	buses{ ^vertexMgr.buses}

	freeGroup{|vertexName| ^vertexMgr.freeGroup(vertexName)}

	listVertexs{|host| ^vertexMgr.listVertexs(host)}

	playSynth{|host, vertexName| ^vertexMgr.playSynth(host, vertexName)}

	playControl{|host, vertexName| ^vertexMgr.playControl(host, vertexName)}

	stopControl{|host, vertexName| ^vertexMgr.stopControl(host, vertexName)}

	controlVertex{|host, vertexName| ^vertexMgr.controlVertex(host, vertexName)}

	vertexControls{|vertexName| ^vertexMgr.vertexControls(vertexName)}


	////  GUI WINDOWS STUFF
	//    FIX: should probably generalize this later
	newPeerWindow {
		peerWin = Window("Mesh!!!!").minimize;
		peerWin.alwaysOnTop=true;
		peerWin.layout = VLayout.new.add(peerView = ListView.new);

		// to get updates, just add a dependant
		addrBook.addDependant({|addrBook, what, who|
			{peerView.items = addrBook.peers.collectAs({|peer|
				peer.name ++ " | " ++ peer.addr.ip ++
				" | " ++ if(peer.online,
					"online", "offline");
			}, Array)}.defer;
		});
	}

	togglePeerWindow {
		if (peerWin.visible==true)
		{peerWin.visible=false}
		{peerWin.visible=true}
	}

	toggleSynthdefLibWindow { synthdefMgr.toggleSynthdefLibWindow }

}