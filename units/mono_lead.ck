BPM tempo;

SawOsc lead => LPF filter => dac;
Envelope envelope => blackhole;

//

67 => int origin;
origin + 7 => int target;

time swipeEnd;

//

.05 => lead.gain;

2.0 => filter.Q;

//

Shred filterFreqShred;
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

while(true) {  
    tempo.note * 16 => now;

    for (0 => int beat; beat < 2; beat++) {
        //    
        if (beat == 0) spork ~ modFilterFreq(filter, tempo.note, 50 => Std.mtof, 88 => Std.mtof, .5) @=> filterFreqShred;
        else if (beat == 1) spork ~ modFilterFreq(filter, tempo.quarterNote, 50 => Std.mtof, 88 => Std.mtof, .1) @=> filterFreqShred;

        tempo.halfNote => envelope.duration;
        swipeFreq(origin => Std.mtof, target => Std.mtof);    
        (tempo.note * 2) - envelope.duration() => now; // 2

        //
        swipeFreq(envelope.target(), origin => Std.mtof);       
        tempo.halfNote => now;    
        (tempo.note * 1.5) - envelope.duration() => now; // 4

        //    
        swipeFreq(envelope.target(), origin + 4 => Std.mtof);        
        (tempo.note * 2) - envelope.duration() => now; // 6

        //
        tempo.eighthNote => envelope.duration;
        swipeFreq(envelope.target(), origin => Std.mtof);    
        (tempo.note * .5) - envelope.duration() => now; // 6.5

        //    
        if (beat == 1) {
            Machine.remove(filterFreqShred.id());
            spork ~ modFilterFreq(filter, tempo.eighthNote, 50 => Std.mtof, 88 => Std.mtof, .1) @=> filterFreqShred;
        }
        
        tempo.halfNote => envelope.duration;
        swipeFreq(envelope.target(), origin + 12 => Std.mtof);        
        tempo.note - envelope.duration() => now; // 7.5

        //
        if (beat == 1) {
            Machine.remove(filterFreqShred.id());
            spork ~ modFilterFreq(filter, tempo.quarterNote / 3, 50 => Std.mtof, 88 => Std.mtof, .1) @=> filterFreqShred;
        }        

        swipeFreq(envelope.target(), origin => Std.mtof);    
        (tempo.note * .5) - envelope.duration() => now; // 8
        
        Machine.remove(filterFreqShred.id());
    }
}

function void swipeFreq(float startFreq, float endFreq) {
    startFreq => envelope.value;
    endFreq => envelope.target;
    
    now + envelope.duration() => swipeEnd;

    while(now < swipeEnd) {
        envelope.value() => lead.freq;
        samp => now;
    }
}