// I'll add documentation here soon

(
~keyC = 0;
~keyCs = 1;
~keyD = 2;
~keyDs = 3;
~keyE = 4;
~keyF = 5;
~keyFs = 6;
~keyG = 7;
~keyGs = 8;
~keyA = 9;
~keyAs = 10;
~keyB = 11;

~aeolian = [0, 2, 3, 5, 7, 8, 10];
~blues = [0, 2, 3, 4, 5, 7, 9, 10, 11];
~chrom = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
~diaMinor = [0, 2, 3, 5, 7, 8, 10];
~dorian = [0, 2, 3, 5, 7, 9, 10];
~harMinor = [0, 2, 3, 5, 7, 8, 11];
~indian = [0, 1, 1, 4, 5, 8, 10];
~locrian = [0, 1, 3, 5, 6, 8, 10];
~lydian = [0, 2, 4, 6, 7, 9, 10];
~major = [0, 2, 4, 5, 7, 9, 11];
~melMinor = [0, 2, 3, 5, 7, 8, 9, 10, 11];
~minor = [0, 2, 3, 5, 7, 8, 10];
~mixolydian = [0, 2, 4, 5, 7, 9, 10];
~natMinor = [0, 2, 3, 5, 7, 8, 10];
~pentatonic = [0, 2, 4, 7, 9];
~phrygian = [0, 1, 3, 5, 7, 8, 10];
~turkish = [0, 1, 3, 5, 7, 10, 11];


~scale = {|root,mode,oct| ((root + (12 * oct)) + mode).midicps};
~midiscale = {|root,mode,oct| (root + (12 * oct)) + mode};

)
