BPM tempo;

Gain master;
SinOsc voice1 => LPF filter => master;
SinOsc voice2 => master;
master => ADSR adsr => Dyno dynamics => dac;

Envelope envelope => blackhole;

//

27 + 5 => Std.mtof => filter.freq;
3.0 => filter.Q;

1 => voice1.gain;
.025 => voice2.gain;
(1.0 / 2.0) => master.gain;

(5 :: ms, 15 :: ms, 1, 100 :: ms) => adsr.set;

dynamics.compress();
.8 => dynamics.thresh;

110 :: ms => envelope.duration;

//

27 => int key;
[key, key, key - 3, key - 3] @=> int sequence[];

//

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        tempo.quarterNote => now;

        sequence[step] => Std.mtof => voice1.freq;
        sequence[step] + 12 => Std.mtof => voice2.freq;

        1 => adsr.keyOn;
        swipeSinFreq(sequence[step] + 12 => Std.mtof, sequence[step] => Std.mtof);
        (tempo.halfNote - envelope.duration()) - adsr.releaseTime() => now;

        1 => adsr.keyOff;
        adsr.releaseTime() => now;

        (tempo.note * 2) - (tempo.quarterNote + tempo.halfNote) => now;
    }
}

function void swipeSinFreq(float startFreq, float endFreq) {
    startFreq => envelope.value;
    endFreq => envelope.target;
    
    now + envelope.duration() => time swipeEnd;

    while(now < swipeEnd) {
        envelope.value() => voice1.freq;
        samp => now;        
    }
}