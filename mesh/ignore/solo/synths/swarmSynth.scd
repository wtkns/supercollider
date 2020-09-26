// CtkSynthDef(\swarmSaw, {|
// 	lagArr = \lagArr.kr(1!~numVoices),
// 	cpsArr = \cpsArr.kr({ 1000.0.linrand }.dup(~numVoices) ),
// 	syncCpsArr = \syncCpsArr.kr( {100.0.linrand }.dup(~numVoices)),
// 	ampArr = \ampArr.kr( {0.5.linrand }.dup(~numVoices)),
// 	panArr = \panArr.kr( { rrand(-1.0, 1.0) }.dup(~numVoices)),
// 	lpfFrq = \lpfFrqArr.kr( { rrand(100, 1000) }.dup(~numVoices)),
// 	lpfRq = \lpfRqArr.kr( { rrand(0.05, 0.999) }.dup(~numVoices)),
// 	lpfLagArr = \lpfLagArr.kr(0.5!~numVoices)|
//
// 	var signal = Mix.fill(~numVoices,
// 		{| i |
// 			var drone = SyncSaw.ar(
// 				syncCpsArr[i].lag3(lagArr[i]),
// 				cpsArr[i].lag3(lagArr[i]),
// 				(ampArr[i] * ~numVoices.reciprocal).lag3(lagArr[i])
// 			) ;
// 			Pan2.ar(
// 				RLPF.ar(drone, lpfFrq[i].lag(lpfLagArr[i]), lpfRq[i].lag(lpfLagArr[i])),
// 			panArr[i]);
// 	});
//
// 	Out.ar(0, signal);
//
// });