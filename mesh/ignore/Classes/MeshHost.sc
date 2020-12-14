MeshHost {

	var <name, <>addr, <>online;

	*new {|name, addr, online = true|
		^super.newCopyArgs(name.asSymbol, addr, online);
	}

	*newFrom { |item|
		if(item.isKindOf(this)) { ^item };
		item = item ?? { this.getHostName };
		^this.new(item, MeshHostAddr.localAddr)
	}

	*getHostName {
		var cmd;
		"getting hostname".postln;
		cmd = Platform.case(
			\osx,       { ^ ("hostname".unixCmdGetStdOut.split($.)[0]).stripWhiteSpace.asSymbol},
			\linux,     { ^ ("hostname".unixCmdGetStdOut).stripWhiteSpace.asSymbol }
		);
	}

	doesNotUnderstand {|selector ... args|
		var result = nil;
		(result = addr.tryPerform(selector, *args)) !? { ^ result };
	}

	ping {|msg| this.addr.sendMsg('/ping') }

	chat {|msg| this.addr.sendMsg('/chat', msg) }

	printOn { |stream| stream << this.class.name << "(" << [name, addr, online] << ")" }

}

BroadcastHost {
	var <name, <>addr, <>online;

	*new {|name, addr, online = true|
		^super.newCopyArgs(name.asSymbol, addr, online);
	}

	sendMsg {|...args|
		addr.sendMsg(*args);
	}

}
