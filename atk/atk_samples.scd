






// ------------------------------------------------------------
// push and rtt transformer
// granular klank stream source

// ------------------------------------------------------------



// define encoder matrix
~encoder = FoaEncoderMatrix.newAtoB

// choose transformer
~transformer1 = 'rtt'
~transformer2 = 'push'

(
{
    var sig;                     // audio signal
    var angle, azim;            // angle and azimuth control
    var freq;

    // ir...
    var gain = -18;

    var freqs = [50.0, 7000.0], gains = [-24, 0], rtimes = [0.1, 2.0];
    var frequencies, amplitudes, ringTimes;
    var numModes = 20;

    var density = 20;                  // grain/klank density

    var rttFreq = 10 * density;


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.kind).postln;
    "Ambisonic transforming via % transformer".format(~transformer1).postln;
    "Ambisonic transforming via % transformer".format(~transformer2).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;


    // calculate klank args
    frequencies = Array.rand(numModes, freqs.at(0), freqs.at(1)).sort;
    amplitudes = Array.rand(numModes, gains.at(0), gains.at(1)).sort.reverse.dbamp;
    ringTimes = Array.rand(numModes, rtimes.at(0), rtimes.at(1)).sort.reverse;


    // angle ---> top         = push to plane wave
    //          bottom    = omni-directional
    angle = MouseY.kr(pi/2, 0);

    // azimuth -> hard left     = back
    //          centre     = centre
    //          hard right     = back
    azim = MouseX.kr(pi, -pi);


    // ------------------------------------------------------------
    // test sig
    sig = Dust.ar(Array.fill(4, density / 4));

    // ------------------------------------------------------------
    // encode
    sig = FoaEncode.ar(sig, ~encoder);

    // ------------------------------------------------------------
    // transform 1 (rtt)
    sig = FoaTransform.ar(
        sig,
        ~transformer1,
        LFSaw.ar(rttFreq, pi, add: pi),
        LFSaw.ar(rttFreq**(1/3), pi, add: pi),
        LFSaw.ar(rttFreq**(2/3), pi, add: pi)
    );


    // ------------------------------------------------------------
    // Klank
    sig = gain.dbamp * Klank.ar(
        `[ frequencies, amplitudes, ringTimes ],
        sig
    );


    // ------------------------------------------------------------
    // transform 2 (push)
    sig = FoaTransform.ar(sig, ~transformer2, angle, azim);



    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    ~renderDecode.value(sig, ~decoder)

}.scope;
)
// ------------------------------------------------------------
























// ------------------------------------------------------------
// proximity transform
// comb filtered dust noise source, panned across the front


// define encoder matricies
(
~encoder = [
    FoaEncoderMatrix.newDirection(pi/6),
    FoaEncoderMatrix.newDirection(pi/12),
    FoaEncoderMatrix.newDirection(pi.neg/12),
    FoaEncoderMatrix.newDirection(pi.neg/6)
]
)

// choose transformer
~transformer = 'proximity'

(
{
    var sig;                            // audio signal
    var dist;                           // distance control
    var freq;
    var density = 10;                   // grain density


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.at(0).kind).postln;
    "Ambisonic transforming via % transformer".format(~transformer).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // frequencies
    freq = 220 * [ 4, 5, 7, 6 ] / 4;

    // dist  ---> top           = 0.5
    //            bottom        = 0.05
    dist = MouseY.kr(0.5, 0.05);


    // ------------------------------------------------------------
    // test sig
    sig = Dust.ar(Array.fill(4, density / 4));


    // ------------------------------------------------------------
    // comb filter
    sig = BPF.ar(sig, freq, mul: 18.dbamp);
    sig = CombL.ar(sig, freq.reciprocal, freq.reciprocal, mul: 9.neg.dbamp);


    // ------------------------------------------------------------
    // encode
    sig = Mix.fill(sig.numChannels, { arg i;  FoaEncode.ar(sig.at(i), ~encoder.at(i)) });


    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, ~transformer, dist);



    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    ~renderDecode.value(sig, ~decoder)

}.scope;
)
// ------------------------------------------------------------






// ------------------------------------------------------------
// B-format examples, produced via the ATK
// B-format soundfile read from disk
Atk.userSoundsDir.post

// read a whole sound into memory
// remember to free the buffer later!
// (boot the server, if you haven't!)
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Anderson-Pacific_Slope.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Howle-Calling_Tunes.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Pampin-On_Space.wav")



(
{
    var sig;                            // audio signal


    // display encoder and decoder
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // ------------------------------------------------------------
    // test sig
    sig = PlayBuf.ar(~sndbuf.numChannels, ~sndbuf, BufRateScale.kr(~sndbuf), doneAction:2);   // soundfile


    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    ~renderDecode.value(sig, ~decoder)

}.scope;
)

// free buffer
~sndbuf.free
// ------------------------------------------------------------























// ------------------------------------------------------------
// B-format examples, natural soundfield with imaging transform
// B-format soundfile read from disk

// choose transformer
~transformer = 'zoomX'
~transformer = 'pushX'
~transformer = 'directO'



// read a whole sound into memory
// remember to free the buffer later!
// (boot the server, if you haven't!)
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Hodges-Purcell.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Leonard-Orfeo_Trio.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Courville-Dialogue.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Leonard-Chinook.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Leonard-Fireworks.wav")
~sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/b-format/Anderson-Nearfield.wav")


(
{
    var sig;                            // audio signal
    var angle;                          // angle control


    // display transformer & decoder
    "Ambisonic transforming via % transformer".format(~transformer).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // gain ---> top            = 90 deg
    //           bottom         = 0 deg
    angle = MouseY.kr(pi/2, 0);


    // ------------------------------------------------------------
    // test sig
    sig = PlayBuf.ar(~sndbuf.numChannels, ~sndbuf, BufRateScale.kr(~sndbuf), doneAction:2);   // soundfile

    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, ~transformer, angle);


    // ------------------------------------------------------------
    // decode (via ~renderDecode)
    ~renderDecode.value(sig, ~decoder)

}.scope;
)

// free buffer
~sndbuf.free
// ------------------------------------------------------------













(
var cond, encoder, decoder, sndbuf, synth;

// boot the server
s.boot;

// wait for the server to boot
cond = Condition.new;
s.waitForBoot({

    Routine.run({

        // define an UHJ encoder
        encoder = FoaEncoderKernel.newUHJ;

        // define an HRTF decoder
        decoder = FoaDecoderKernel.newListen(1002);
        decoder = FoaDecoderKernel.newCIPIC(165);

        // load a UHJ sound file into a buffer
        sndbuf = Buffer.read(s, Atk.userSoundsDir ++ "/uhj/Palestrina-O_Bone.wav");

        s.sync(cond);

        // synth to encode a UHJ file and decode using an HRTF
        SynthDef(\kernelEncodeDecode, {arg buffer;
            var out, src, encode;

            // our stereo source signal
            src = PlayBuf.ar(sndbuf.numChannels, buffer, BufRateScale.kr(buffer));

            // encode using a UHJ encoder
            encode = FoaEncode.ar(src, encoder);

            //  decode using an HRTF decoder
            out = FoaDecode.ar(encode, decoder);

            Out.ar(0, out);
        }).add;

        s.sync(cond);

        // play the synth
        synth = Synth(\kernelEncodeDecode, [\buffer, sndbuf]);

        // press command period when done
        CmdPeriod.doOnce({
            synth.free;
            encoder.free;
            decoder.free;
            sndbuf.free});
    })
})
)