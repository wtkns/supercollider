Beacon {

	var oscPath, <pollPeriod, beaconKeeper, inDefName, outDefName;

	*new {|mesh, host| ^ super.new.init(mesh, host) }

	init {|mesh, host|

		var name = mesh.name;
		// Mesh.me.postln;

		inDefName = ( name ++ "BeaconIn").asSymbol;
		outDefName = (name ++ "BeaconOut").asSymbol;

		// make an OSC Path from the mesh name
		oscPath = ("/" ++ name ++ "Beacon").asSymbol;

		// Make the OSC responder definitions.
		// these are OSC Defs, so they can be managed
		// globally, eg after creating a mesh, try: OSCdef.all;
		this.makeOSCdefs(mesh, host);

		// set the broadcast flag (whether or not broadcast messages can be sent)
		MeshHostAddr.broadcastFlag = true;

		// set the frequency of testing to see if hosts are online
		pollPeriod = 1.0;

		// Start a function that periodically checks whether hosts are still online.
		// This continues running, even after Cmd+Period
		beaconKeeper = SkipJack({
			try { Mesh.broadcastAddr.sendMsg(oscPath, host.name)}
			{|error| this.networkError(error)};
			mesh.hosts.checkTimeouts;
		}, pollPeriod, false);
	}

	networkError {|error|
		error.postln;
		"Network Error! beacon stopped.".postln;
		// TODO: retry counter?
		"Try Mesh.current.hosts.beacon.start;".postln;
		this.stop;
	}

	makeOSCdefs {|mesh, host|

		var replyPath = (oscPath ++ "-reply").asSymbol;

		// This OSC Def Receives a msg from the Beacon
		// updates the host list, AND replies to the Beacon
		OSCdef(outDefName, {|msg, time, addr, recvPort|
			var key = msg[1].asString.asSymbol;
			addr = addr.as(MeshHostAddr);
			mesh.hosts.checkHost(key, addr);
			addr.sendMsg(replyPath, host.name);
		}, oscPath, recvPort: host.addr.port);

		// This OSC Def receives the reply
		// and updates the host list.
		OSCdef(inDefName, {|msg, time, addr, recvPort|
			var key = msg[1].asString.asSymbol;
			addr = addr.as(MeshHostAddr);
			mesh.hosts.checkHost(key, addr);
		}, replyPath, recvPort: host.addr.port);

		OSCdef(\ping, {|msg, time, addr, recvPort|
			(msg[1] ++ " pinged on " ++ mesh.name).postln;
			Mesh.broadcastAddr.sendMsg("/pingReply", host.name);
		}, '/ping', recvPort: host.addr.port);

		OSCdef(\chat, {|msg, time, addr, recvPort|
			(msg[1]).postln;
		}, '/chat', recvPort: host.addr.port);

		OSCdef(\pingReply, {|msg, time, addr, recvPort|
			(msg[1] ++ " replied to your ping on: " ++ mesh.name).postln;
		}, '/pingReply', recvPort: host.addr.port);

	}

	ping { |host| Mesh.broadcastAddr.sendMsg("/ping", host.name) }

	start {
		beaconKeeper.start;
	}

	stop {
		beaconKeeper.stop;
	}

	free {
		OSCdef(inDefName).free;
		OSCdef(outDefName).free;
		OSCdef(\ping).free;
		OSCdef(\pingReply).free;
		OSCdef(\chat).free;


	}

}
