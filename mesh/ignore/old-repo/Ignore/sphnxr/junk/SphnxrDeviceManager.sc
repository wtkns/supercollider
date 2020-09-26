SphnxrDeviceManager {
	var <dict;

	*new { ^super.new.init }

	init {
		dict = IdentityDictionary.new;
	}

}

/*
SerialArray {
	var <>name, <>port, <>data;

	*new {|name, portName, numChannels=8, baud=9600|
		^super.new.init(name, portName, numChannels, baud)}

	init {|name, portName, numChannels, baud|
		this.name=name;
		data=Array.newClear(numChannels);
		port = SerialPort(portName, baud, crtscts: true);
		Routine.run({
			var byte, index= 0, payload= Array.newClear(numChannels*2);
			inf.do{
				while({byte= port.read; byte.notNil}, {
					//byte.postln;	//debug
					if(index==0 and:{byte==253}, {//check if first byte is 253
						index= 1;
					}, {
						if(index==1 and:{byte==254}, {//then check if second byte is 254
							index= 2;
						}, {
							if(index>=2 and:{index<(numChannels*2+2)}, {//ok, now start collecting bytes
								payload[index-2]= byte;
								index= index+1;
							}, {
								if(index==(numChannels*2+2) and:{byte==255}, {//until last data byte
									//payload.postln;	//debug
									//everything seems ok so decode payload
									numChannels.do{|i|
										data[i]= ((payload[i*2]<<2)+payload[i*2+1])/1024;
										//convert to decimal 0-1.0
									};
									//done. reset index to prepare for new message
									index= 0;
								}, {
									//something broke or beginning - restart
									"restart".postln;	//debug
									index= 0;
								});
							});
						});
					});
				});
			};
		});
	}
}

*/