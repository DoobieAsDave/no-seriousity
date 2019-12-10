BPM tempo;

SndBuf sample => LPF filter => dac;
filter => Delay rev1 => dac;
filter => Delay rev2 => dac.left;
filter => Delay rev3 => Pan2 stereo => dac;
rev1 => rev1;
rev2 => rev2;
rev3 => rev3;

//

me.dir(-1) + "audio/sample.wav" => sample.read;
sample.samples() => sample.pos;
2 => sample.interp;

80 => Std.mtof => filter.freq;
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

while(true) {
    for (0 => int step; step < 4; step++) {
        tempo.quarterNote => now;

        if (step != 3) {
            .85 => sample.rate;
            0 => sample.pos;
            tempo.note - tempo.quarterNote => now;
        }
        else {
            for (0 => int subStep; subStep < 2; subStep++) {
                if (subStep == 0) .675 => sample.rate;
                else .75 => sample.rate;
                
                0 => sample.pos;
                (tempo.note - tempo.quarterNote) / 2 => now;
            }
        }       
    }
}