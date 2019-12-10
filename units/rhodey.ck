BPM tempo;

Rhodey rhodey => Gain volume => LPF filter => Pan2 stereo => dac;

filter => Delay rev1 => dac;
filter => Delay rev2 => dac.right;
filter => Delay rev3 => dac;
rev1 => rev1;
rev2 => rev2;
rev3 => rev3;

//

.1 => volume.gain;

2.0 => filter.Q;

tempo.note * 2 => rev1.max => rev2.max => rev3.max;
tempo.halfNote * Math.random2f(.5, 1.5) => rev1.delay;
tempo.quarterNote * Math.random2f(.5, 2.0) => rev2.delay;
tempo.eighthNote / 3 => rev2.delay;
.6 => rev1.gain;
.2 => rev2.gain;
.3 => rev3.gain;

//

float filterFreq;
float stereoPan;

function void modFilterFreq(FilterBasic filter, dur modTime, float min, float max, float amount) {
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
function void modStereoPan(Pan2 stereo, dur modTime, float min, float max, float amount) {
    amount => float step;
    max - min => float range;
    (range / amount) * 2 => float steps;

    min => stereoPan;

    while(true) {
        stereoPan => stereo.pan;

        if (stereoPan >= max) {
            amount * -1 => step;
        }
        else if (stereoPan <= min) {
            amount => step;
        }

        step +=> stereoPan;

        modTime / steps => now;
    }
}


//

spork ~ modFilterFreq(filter, tempo.note / 3, 75 => Std.mtof, 110 => Std.mtof, .5);
spork ~ modStereoPan(stereo, tempo.note * Math.random2f(.5, 1.5), -.2, 1, .01);

51 => int key;
int sequence[];
[0, 2, 4, 5, 7, 9, 11, 12] @=> int scale[];

while(true) {
    [key, key + 4, key + 7, key + 11] @=> sequence;

    repeat(4) {
        for (0 => int step; step < sequence.cap(); step++) {            
            sequence[step] => Std.mtof => rhodey.freq;

            1 => rhodey.noteOn;
            tempo.quarterNote => now;
            
            1 => rhodey.noteOff;            
        }
    }

    [key + 14, key + 7, key + 11] @=> sequence;
    repeat(3) {
        tempo.quarterNote => now;
        for (0 => int step; step < sequence.cap(); step++) {            
            sequence[step] => Std.mtof => rhodey.freq;

            1 => rhodey.noteOn;
            tempo.quarterNote => now;

            1 => rhodey.noteOff;
        }
    }
    tempo.note => now;
}