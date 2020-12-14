MeshHostsManager {
	var <all, <>timeouts, <>beacon;

	*new {|mesh, thisHost| ^ super.new.init(mesh, thisHost) }

	init {|mesh, thisHost|
		all = IdentityDictionary.new;
		timeouts = IdentityDictionary.new;
		beacon = Beacon.new(mesh, thisHost);
		this.addHost(thisHost);
	}

	addHost {|host|
		host = host.as(MeshHost);
		all.put(host.name, host);
		all.changed(\addedHost, host);
		this.setOnline(host);
	}

	now { ^ Main.elapsedTime }

	at {|key|
		if (key == \broadcast) {^ Mesh.broadcastAddr};
		^ all.at(key) }

	names { ^ all.keys.asArray }

	exists {|key| ^ all.includesKey(key) }

	isOnline {|key| ^ all.at(key).online }

	checkTimeouts {
		timeouts.keysValuesDo({|key, lastHeardFrom|
			var host = all.at(key);
			if (host.online){
				if (this.timedOut(lastHeardFrom))
					 {this.setOffline(host)}
			}
		})
	}

	setOffline {|host|
		host.online = false;
		"Host % left the mesh\n".postf(host.name);
		all.changed(\offlineHost, host);
	}

	setOnline {|host|
		host.online = true;
		"Host % joined the mesh\n".postf(host.name);
		all.changed(\onlineHost, host);
	}

	timedOut {|lastHeardFrom|
		var now = Main.elapsedTime;
		^ (now - lastHeardFrom) > (beacon.pollPeriod * 2)
	}

	printOn { |stream|
		 stream << "Available hosts: " << this.allPrettyHosts;
	}

	prettyHost {|key|
		var host = all.at(key);
		var substrng = ("(" ++ key ++ " : ");
		if (host.online)
			{substrng = substrng ++ "online"}
			{substrng = substrng ++ "offline"};
		substrng = substrng ++ " : " ++ host.ip ++ ") \n";
		^ substrng;
	}

	allPrettyHosts { |string = ""|
		all.keysDo({|key| string = string ++ this.prettyHost(key) });
		^ string;
	}

	resetTimeout {|key|
		timeouts[key] = this.now;
	}

	makeNewHost {|key, addr|
		var host = MeshHost(key, addr);
		this.addHost(host);
		this.resetTimeout(key);
	}

	changeHostAddr {|host, addr|
	 	host.addr = addr;
		this.resetTimeout(host.name);
		this.setOnline(host);
	}

	checkHost {|key, addr|
		// If it's new:
		if (this.exists(key).not)
		{ this.makeNewHost(key, addr) }

		// otherwise get the old host info
		{
			// If the address changed
			if (all.at(key).addr.matches(addr).not)
			{ this.changeHostAddr(all.at(key), addr) }

			// otherwise, welcome back.
			{ if (all.at(key).online == false)
					{ this.setOnline(all.at(key)) };
				this.resetTimeout(key);
			};
		}
	}

	free {|host|
		this.setOffline(host);
		beacon.stop;
		beacon.free;
	}

}
