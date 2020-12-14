
shaper:
{BufRd

phase ctkctl
buffer as a fill with env
}
use as ctk synth controller

use interpolation on a small buffer to save resources

better linlin, no wavetable format fill fillwithenv:

reader = LinLin.kr(ctkctl, 0?, 1?, 0, BufFrames.kr(bufShape));
shape = BufRd.kr(1, bufShape, reader, 0, 2);