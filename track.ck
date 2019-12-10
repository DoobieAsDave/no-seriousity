.75 => dac.gain;

BPM tempo;
tempo.setBPM(122.0);

/* Machine.add(me.dir() + "drums/hihat.ck");
Machine.add(me.dir() + "units/mono_lead.ck");
while(true) second => now; */

int kickId, clapId, hihatId, sizzleId, padId, leadId, bassId, recordId;

Machine.add(me.dir() + "record");

Machine.add(me.dir() + "units/pad.ck") => padId;
tempo.note * 8 => now;

Machine.add(me.dir() + "drums/hihat.ck") => hihatId;
tempo.note * 4 => now;

Machine.add(me.dir() + "drums/clap.ck") => clapId;
tempo.note * 4 => now;

Machine.add(me.dir() + "drums/kick.ck") => kickId;
Machine.add(me.dir() + "units/mono_lead.ck") => leadId;
Machine.add(me.dir() + "units/808.ck") => bassId;

tempo.note * 16 => now;

repeat(4) {
    Machine.add(me.dir() + "drums/sizzle.ck") => sizzleId;
    tempo.note * 3 => now;
    Machine.remove(sizzleId);
    tempo.note => now;    
        
    Machine.add(me.dir() + "drums/sizzle.ck") => sizzleId;
    tempo.note * 3 => now;
    Machine.remove(sizzleId);
    tempo.note => now;    
}

tempo.note * 8 => now;

Machine.remove(clapId);
tempo.note * 8 => now;

Machine.remove(hihatId);
Machine.remove(kickId);
tempo.note * 2 => now;

Machine.remove(bassId);
tempo.note * 4 => now;

Machine.remove(leadId);
tempo.note * 2 => now;

Machine.remove(padId);
Machine.remove(recordId);

Machine.status();