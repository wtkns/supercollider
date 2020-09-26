// =====================================================================
// SuperCollider Workspace
// =====================================================================

(

var mainFile = "/Users/james/git/wtkns/solo/main.scd";

thisThread.randSeed = 1460.rand;
t = TempoClock(90/60 * 3/2).permanent_(true);
TempoClock.default = t;

~preview = true;
~timeRecord = 60;

p = File.readAllString(mainFile).interpret;

)