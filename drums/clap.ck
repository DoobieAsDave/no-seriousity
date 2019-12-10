BPM tempo;

SndBuf clap => dac;

//

me.dir(-1) + "audio/clap.wav" => clap.read;
clap.samples() => clap.pos;
.5 => clap.gain;

//

[
    0, 0, 0, 0,
    0, 0, 0, 0,
    1, 0, 0, 0,
    0, 0, 0, 0
] @=> int sequence[];

while(true) {
    for (0 => int step; step < sequence.cap(); step++) {
        if (sequence[step]) {
            0 => clap.pos;
        }

        tempo.note / sequence.cap() => now;
    }
}