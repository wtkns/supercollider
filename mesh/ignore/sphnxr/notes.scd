// dev notes

// need to set up a way to use SynthDescLib to get control values from remote machines.

//
// old way:
//          ~me.effectSet(\distortion, \postGain, 0.12);
//
//          or on a remote peer with:
//          ~addrBook.send(\river, "/effectSet", \distortion, \postGain, 0.12);



// lookup a named effect
SynthDescLib.global.at(~addrBook.me.effectBank.dict[\reverb][1].defName);

// GET All Effect Controls Names:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({(key ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.postln})}
)



// GET All Effect Controls AND Values:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(key ++ ":  ").post;
				(control++": "++value).postln})}})}
)

// GET ONE Effect Controls AND Values:

(
~effectLookup = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	(synth !== nil).if({
		//(name ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(control++": "++value).postln})}})}
)

// then:

~effectLookup.value(\distortion);
~effectLookup.value(\reverb);

~rose.setEffect(\reverb, \room, 0.99);
~rose.setEffect(\reverb, \mix, 0.99);
~rose.setEffect(\reverb, \damp, 0.99);


// Collect One Effect Controls AND Values into dict:

(
~effectLookupDict = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	var dict = Dictionary.new;
	dict.postln;
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				dict.add(control -> value)})}});
	dict.postln;

})

// then:

a= ~effectLookupDict.value(\reverb);
a.postln;

// SET Effect Control Value:

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.5);
a= ~effectLookupDict.value(\reverb);
a.postln;

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.75);
a= ~effectLookupDict.value(\reverb);
a.postln;


synths to set up:

	// synthdefs
	//granular
	//fm
	//sinsynth
	//polysynth
	//vocoder

