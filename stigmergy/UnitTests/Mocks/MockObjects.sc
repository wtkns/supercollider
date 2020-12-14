MockMesh {
	var <>name;

	*new {|name|
		^ super.new.init(name)
	}

	init {|name|
		name = name;
		postf("Mock Mesh Created: % \n", (name));
	}

}

MockBeacon {
	var <>manager, <>beaconKeeper, <>fakeHosts, <>pollPeriod;

	*new {|mgr, thisHost, poll|
		^ super.new.init(mgr, thisHost, poll)
	}

	init {|mgr, thisHost, poll|
		manager = mgr;
		pollPeriod = poll;
		beaconKeeper = this.fakeBeaconAdd;
		fakeHosts = IdentityDictionary.new;
		this.fakeHostAdd(thisHost.name);
	}

	nextFakeIp {
		^ "192.168.0." ++ (manager.all.size + 100)
	}

	fakeHostAdd {|key|
		var ip = this.nextFakeIp;
		var port = 57110;
		var addr = MeshHostAddr(ip, port);
		var arry = Array.with(addr, true);
		manager.checkHost(key, addr);
		fakeHosts.put(key, arry);
	}

	fakeHostSetOffline{|key|
		fakeHosts.at(key).put(1,false);
	}

	isOnline { |host|	^	host[1]	}

	hostAddr { |host|	^	host[0] }

	fakeBeaconAdd {
		^ SkipJack({

			fakeHosts.keysValuesDo({|key, host|
				 if (this.isOnline(host))
					{ manager.checkHost(key, this.hostAddr(host)) };
			});

			manager.checkTimeouts;

			}, pollPeriod, false);

		}


}
