BPM tempo;

SndBuf sizzle => Pan2 stereo => dac;

//

me.dir(-1) + "audio/sizzle.wav" => sizzle.read;
sizzle.samples() => sizzle.pos;
.175 => sizzle.gain;
2 => sizzle.interp;

//

function void modSizzleGain(dur duration) {
    while(sizzle.gain() >= 0.0) {
        sizzle.gain() - .01 => sizzle.gain;
        duration / (.175 / .01) => now;             
    }
}

//

Shred sizzleGainShred;

while(true) {
    spork ~ modSizzleGain(tempo.note * 3) @=> sizzleGainShred;

    repeat(4) {
        0 => stereo.pan;
        0 => sizzle.pos;
        tempo.eighthNote => now;
    }

    Math.random2(1, 3) => int rep;
    repeat(rep) {
        sizzle.rate() -.075 => sizzle.rate;
        Math.random2(0, (sizzle.samples() * .1) => Std.ftoi) => sizzle.pos;
        tempo.eighthNote / rep => now;
    }

    repeat(3) {
        1 => sizzle.rate;
        Math.random2f(-.3, .3) => stereo.pan;
        0 => sizzle.pos;
        tempo.eighthNote => now;
    }

    Machine.remove(sizzleGainShred.id());
}