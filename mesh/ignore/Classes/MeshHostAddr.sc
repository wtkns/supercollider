MeshHostAddr : NetAddr {

	var <>ports;

	*new { arg hostname, ports;
		ports = ports.asArray;
		^super.new(hostname, ports.first).ports_(ports)
	}

	*newFrom { |item|
		if(item.isKindOf(this)) { ^item };
		if(item.isKindOf(NetAddr)) {
			^this.new(item.ip, item.port)};
		^ "I dont know what to do with this!".error;
	}

	sendRaw{ arg rawArray;
		ports.do{ |it|
			this.port_( it );
			^super.sendRaw( rawArray );
		}
	}

	sendMsg { arg ... args;
		ports.do{ |it|
			this.port_( it );
			super.sendMsg( *args );
		}
	}

	sendBundle { arg time ... args;
		ports.do{ |it|
			this.port_( it );
			super.sendBundle( *([time]++args) );
		}
	}
}
