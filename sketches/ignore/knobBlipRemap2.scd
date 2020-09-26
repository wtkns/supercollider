(
// supercollider code for reading 6 10bit analog values via serial 
// protocol: 253 254 nn nn nn nn nn nn nn nn nn nn nn nn  255 
// nn comes in pairs. �first nn are the upper 8bits and the second are the lower 2 bits. 
// values are ranged from 0 - 1023 

var port, portName; 
var blip, note, ctl;
var fundFreqEnv, formFreqEnv, bandWidthEnv;

// declare mapping envelopes
fundFreqEnv = Env.new([0.1, 20, 1000, 10000],[0.5, 0.25, 0.25], \exp);
formFreqEnv = Env.new([20, 5000],[1], \exp);
bandWidthEnv = Env.new([0.5, 100],[1], \exp);


// open serial port. double check "tty.usbserial" and baud rate
// i don't know how to use crtscts ?

portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
� � � ("connected to"+portName).inform; 
}, { 
� � � � "no port with name tty.usbserial found".inform; 
}); 

// boot the server
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);
s.boot;
s.waitForBoot({
	
	ctl = 6.collect({CtkControl.play});

	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp;
		var env, pulse, numharms, reson, rq, ampScale, reverb;
		      formFreq = formFreq +50; 
			rq = bandWidth+1/(formFreq+1);
			ampScale = 1/rq;
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, 1);
			reson = Resonz.ar((pulse), formFreq, rq, ampScale);
			reverb = FreeVerb.ar(reson, mix, room, damp);
			Out.ar(0, Pan2.ar(Limiter.ar(reverb, 1.0, 0.01), 0));
	}, [0.1, 0.1]);

	Routine.run({ 
	� � � � var byte, index= 0, payload= Array.newClear(14), data= Array.newClear(6); 
	� � � � inf.do{ 
	� � � � � � � � while({byte= port.read; byte.notNil}, { 
	� � � � � � � � � � � � //byte.postln; //debug 
	� � � � � � � � � � � � if(index==0 and:{byte==253}, { 
	� � � � � � � � � � � � � � � � index= 1; 
	� � � � � � � � � � � � }, { 
	� � � � � � � � � � � � � � � � if(index==1 and:{byte==254}, { 
	� � � � � � � � � � � � � � � � � � � � index= 2; 
	� � � � � � � � � � � � � � � � }, { 
	� � � � � � � � � � � � � � � � � � � � if(index>=2 and:{index<14}, { 
	� � � � � � � � � � � � � � � � � � � � � � � � payload[index-2]= byte; 
	� � � � � � � � � � � � � � � � � � � � � � � � index= index+1; 
	� � � � � � � � � � � � � � � � � � � � }, { 
	� � � � � � � � � � � � � � � � � � � � � � � � if(index==14 and:{byte==255}, { 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � //payload.postln; //debug 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � //--everything seems ok so decode payload 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � 6.do{|i| 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � data[i]= (payload[i*2]<<2)+payload[i*2+1] +1; 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � }; 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � //--move data into an ctk control array 
											data.postln;
											ctl[0].set(data[0]/1024);   // Room   put them in here
											ctl[1].set(data[1]/1024);    // damp
											ctl[2].set(fundFreqEnv[data[2]/1024] );   // fund Freq ???
											ctl[3].set(formFreqEnv[data[3]/1024] );   // form Freq
											ctl[4].set(bandWidthEnv[data[4]/1024] );  //  bandwidth 
											ctl[5].set(data[5]/1024);   //~mix
											index= 0; 
	� � � � � � � � � � � � � � � � � � � � � � � � }, { 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � //--something broke or beginning - restart 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � "restart".postln; //debug 
	� � � � � � � � � � � � � � � � � � � � � � � � � � � � index= 0; 
	� � � � � � � � � � � � � � � � � � � � � � � � }); 
	� � � � � � � � � � � � � � � � � � � � }); 
	� � � � � � � � � � � � � � � � }); 
	� � � � � � � � � � � � }); 
	� � � � � � � � � � � � � � � � 
	� � � � � � � � }); 
	� � � � }; 
	}); 


	s.scope;
 	s.freqscope;

	note = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).play;
});

CmdPeriod.doOnce({SerialPort.closeAll}); 
) 