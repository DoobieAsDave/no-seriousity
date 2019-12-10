BPM tempo;

SawOsc saw => ADSR adsr => LPF filter => Gain postFX => Echo delay => dac;
delay => Gain feedback => delay;

//

(0 :: ms, 75 :: ms, .75, 50 :: ms) => adsr.set;

8 => filter.Q;

(1.0 / 5.0) => postFX.gain;

tempo.note => delay.max;
tempo.quarterNote / 3 => delay.delay;
.5 => delay.mix;

.5 => feedback.gain;

//

float filterFreq;

function void modFilterFreq(LPF filter, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => filterFreq;

    while(true) {
        filterFreq => filter.freq;
        
        if (filterFreq >= max) {
            amount * -1 => step;
        }
        else if (filterFreq <= min) {
            amount => step;
        }

        step +=> filterFreq;
        
        modTime / steps => now;
    }
}

//

62 => int key;
[key, key + 11, key + 7, key + 3] @=> int sequenceA[];
[tempo.quarterNote * 2, tempo.quarterNote , tempo.quarterNote * .5, tempo.quarterNote * .5] @=> dur durationsA[];

[0, 2, 3, 5, 7, 9, 11, 12] @=> int scale[];

spork ~ modFilterFreq(filter, tempo.note / 2, 100.0, 800.0, .1);

while(true) {
    for (0 => int step; step < sequenceA.cap(); step++) {
        sequenceA[step] + (12 * Math.random2(-2, 0)) => Std.mtof => saw.freq;

        1 => adsr.keyOn;
        durationsA[step] - adsr.releaseTime() => now;
        
        1 => adsr.keyOff;
        adsr.releaseTime() => now;
    }
}
