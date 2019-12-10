BPM tempo;

Gain master;
SawOsc saw1 => master;
SawOsc saw2 => master;
SawOsc saw3 => master;
SawOsc saw4 => master;

master => ADSR adsr => LPF filter => dac;

filter => Delay rev1 => dac;
filter => Delay rev2 => dac.left;
filter => Delay rev3 => Pan2 stereo => dac;
rev1 => rev1;
rev2 => rev2;
rev3 => rev3;

//

(1.0 / 3.0) / 10.0 => master.gain;

(tempo.halfNote * 1.75, tempo.sixteenthNote, master.gain(), tempo.note) => adsr.set;

2.0 => filter.Q;

tempo.note * 2 => rev1.max => rev2.max => rev3.max;
tempo.halfNote * Math.random2f(.5, 1.5) => rev1.delay;
tempo.quarterNote * Math.random2f(.5, 2.0) => rev2.delay;
tempo.note * Math.random2f(.5, 2.0) => rev2.delay;
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

spork ~ modFilterFreq(filter, (tempo.note * 4) / 3, 75 => Std.mtof, 110 => Std.mtof, .5);
spork ~ modStereoPan(stereo, tempo.note * Math.random2f(.5, 1.5), -1, 1, .01);

51 => int key;
[key, key, key - 3, key - 3] @=> int sequence[];
[1, 1, 1, 1] @=> int harmonics[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        sequence[step] => Std.mtof => saw1.freq;
        if (harmonics[step]) sequence[step] + 4 => Std.mtof => saw2.freq;
        else sequence[step] + 3 => Std.mtof => saw2.freq;
        sequence[step] + 7 => Std.mtof => saw3.freq;
        if (harmonics[step]) sequence[step] + 11 => Std.mtof => saw4.freq;
        else sequence[step] + 10 => Std.mtof => saw4.freq;
        
        tempo.quarterNote => now;        

        1 => adsr.keyOn;
        ((tempo.note * 2) - tempo.quarterNote) - adsr.releaseTime() => now;    

        1 => adsr.keyOff;
        adsr.releaseTime() => now;
    }    
}