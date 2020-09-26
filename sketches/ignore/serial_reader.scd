(
//supercollider code for reading eight 10bit analog values 
//protocol: 253 254 nn nn nn nn nn nn nn nn nn nn nn nn 255 
//nn comes in pairs. Êfirst nn are the upper 8bits and the second are the lower 2 bits. ÊA0 to A9 in order 

var ardSms, port; 
var portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 

if(portName.notNil, { 
Ê Ê Ê Ê ardSms= ArduinoSMS(portName, 57600); 
Ê Ê Ê Ê ("connected to"+portName).inform; 
}, { 
Ê Ê Ê Ê "no port with name tty.usbserial found".inform; 
}); 

port= SerialPort(portName, 57600, crtscts: true); 

Routine.run({ 
Ê Ê Ê Ê var byte, index= 0, payload= Array.newClear(20), data= Array.newClear(10); 
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
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê data[i]= (payload[i*2]<<2)+payload[i*2+1]; 
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê }; 
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê //--finished - do something here 
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê data.postln; 
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê 
Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê Ê index= 0; 
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
CmdPeriod.doOnce({port.close}); 
) 
