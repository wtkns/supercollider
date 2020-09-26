(
//supercollider code for reading 2 10bit analog values 
//protocol: 253 254 nn nn nn nn 255 
//nn comes in pairs. Êfirst nn are the upper 8bits and the second are the lower 2 bits. ÊA0 to A1 in order 

var port, portName; 
var blip, note, ctl;
Server.default = s = Server.internal;
s.options.maxNodes_(4096);
s.options.memSize_(16384);

portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 
if(portName.notNil, { 
	port= SerialPort(portName, 57600, crtscts: false); 
Ê Ê Ê ("connected to"+portName).inform; 
}, { 
Ê Ê Ê Ê "no port with name tty.usbserial found".inform; 
}); 

s.boot;
s.waitForBoot({
	
	ctl = 6.collect({CtkControl.play});

	blip = CtkSynthDef(\blipgen, {arg fundFreq, formFreq, bandWidth, room, mix, damp;
		var env, pulse, numharms, reson, rq, ampScale, reverb;
		      formFreq = formFreq +50;
			fundFreq = (fundFreq +1)/2; 
			rq = bandWidth+1/(formFreq+1);
			ampScale = 1/rq;
			numharms = (SampleRate.ir*0.4) / fundFreq;
			pulse = Blip.ar(fundFreq, numharms.floor, 1);
			reson = Resonz.ar((pulse), formFreq, rq, ampScale);
			reverb = FreeVerb.ar(reson, mix/1024, room/1024, damp/1024);
			Out.ar(0, Pan2.ar(Limiter.ar(reverb, 1.0, 0.01), 0));
	}, [0.1, 0.1]);

	Routine.run({ 
	Ê Ê Ê Ê var byte, index= 0, payload= Array.newClear(14), data= Array.newClear(6); 
	Ê Ê Ê Ê inf.do{ 
	Ê Ê Ê Ê Ê Ê Ê Ê while({byte= port.read; byte.notNil}, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //byte.postln; //debug 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê if(index==0 and:{byte==253}, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= 1; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê if(index==1 and:{byte==254}, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= 2; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê if(index>=2 and:{index<14}, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê payload[index-2]= byte; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= index+1; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê if(index==14 and:{byte==255}, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //payload.postln; //debug 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //--everything seems ok so decode payload 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê 6.do{|i| 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê data[i]= (payload[i*2]<<2)+payload[i*2+1] +1; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //--move data into an ctk control array 
										   data.postln;
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê ctl[0].set(data[0]);
										   ctl[1].set(data[1] ); 
										   ctl[2].set(data[2] ); 										   ctl[3].set(data[3] ); 										   ctl[4].set(data[4] ); 										   ctl[5].set(data[5] ); 	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= 0; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }, { 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //--something broke or beginning - restart 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê "restart".postln; //debug 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= 0; 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }); 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }); 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }); 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }); 
	Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê 
	Ê Ê Ê Ê Ê Ê Ê Ê }); 
	Ê Ê Ê Ê }; 
	}); 


	s.scope;
 	s.freqscope;
	note = blip.note().fundFreq_(ctl[2]).formFreq_(ctl[3]).bandWidth_(ctl[4]).room_(ctl[0]).damp_(ctl[1]).mix_(ctl[5]).play;
});

CmdPeriod.doOnce({SerialPort.closeAll}); 
) 
