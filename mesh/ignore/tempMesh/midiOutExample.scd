MIDIClient.init;

m = MIDIOut(0);
m.noteOn(16, 60, 60);
m.noteOn(16, 61, 60);
m.noteOff(16, 61, 60);
m.allNotesOff(16);


MIDIIn.connect; // 1 port midi interface
MIDIIn.sysex = { arg uid, packet; [uid,packet].postln };
MIDIIn.sysrt = { arg src, chan, val;  [src, chan, val].postln; };
MIDIIn.smpte = { arg src, chan, val;  [src, chan, val].postln; };

m.sysex(Int8Array[ 16rf0, 0, 0, 27, 11, 0,16rf7])

m.smpte(24, 16)
m.midiClock
m.start
m.continue
m.stop



//  Using patterns for sending MIDI events

MIDIClient.init;
m = MIDIOut(0);

a = Pbind(\degree, Prand([1, 2, 3, [0, 5]], inf), \bend, Pwhite(0, 76, inf));


// chain a midi event into the pattern and play it (see Pchain)

(a <> (type: \midi, midiout: m)).play;



(
var bpm, val, upper, lower;
bpm = 114.23;
val = (bpm*24).round.asInteger;
upper = val&2r11111110000000>>7;
lower = val&2r00000001111111;
[upper, lower].postln;
)