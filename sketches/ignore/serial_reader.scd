(
//supercollider code for reading eight 10bit analog values 
//protocol: 253 254 nn nn nn nn nn nn nn nn nn nn nn nn 255 
//nn comes in pairs. �first nn are the upper 8bits and the second are the lower 2 bits. �A0 to A9 in order 

var ardSms, port; 
var portName= SerialPort.devices.detect{|x| x.contains("tty.usbserial")}; 

if(portName.notNil, { 
� � � � ardSms= ArduinoSMS(portName, 57600); 
� � � � ("connected to"+portName).inform; 
}, { 
� � � � "no port with name tty.usbserial found".inform; 
}); 

port= SerialPort(portName, 57600, crtscts: true); 

Routine.run({ 
� � � � var byte, index= 0, payload= Array.newClear(20), data= Array.newClear(10); 
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
� � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � � data[i]= (payload[i*2]<<2)+payload[i*2+1]; 
� � � � � � � � � � � � � � � � � � � � � � � � � � � � }; 
� � � � � � � � � � � � � � � � � � � � � � � � � � � � //--finished - do something here 
� � � � � � � � � � � � � � � � � � � � � � � � � � � � data.postln; 
� � � � � � � � � � � � � � � � � � � � � � � � � � � � 
� � � � � � � � � � � � � � � � � � � � � � � � � � � � index= 0; 
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
CmdPeriod.doOnce({port.close}); 
) 