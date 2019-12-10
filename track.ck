.8 => dac.gain;

BPM tempo;
//tempo.setBPM(112.0);
tempo.setBPM(122.0);

/* Machine.add(me.dir() + "units/808.ck");

while(true) second => now; */

int kickId, clapId, hihatId, sampleId;

Machine.add(me.dir() + "record");

Machine.add(me.dir() + "drums/kick.ck") => kickId;
Machine.add(me.dir() + "drums/clap.ck") => clapId;
Machine.add(me.dir() + "drums/hihat.ck") => hihatId;

Machine.add(me.dir() + "units/pad.ck");
Machine.add(me.dir() + "units/mono_lead.ck");
Machine.add(me.dir() + "units/808.ck");




//Machine.add(me.dir() + "units/rhodey.ck");

//Machine.add(me.dir() + "units/sample.ck") => sampleId;
//Machine.add(me.dir() + "units/acid.ck") => acidId;