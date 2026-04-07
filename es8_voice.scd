// ES-8 Voice — SuperCollider as a modular oscillator voice
// Modular sends pitch CV + gate via ES-8, SC sends audio back
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out (sine)
//
// Setup: boot scsynth with ES-8 as device, 8 out / 4 in

// ---- BOOT ----
(
s.options.device = "ES-8";
s.options.numOutputBusChannels = 8;
s.options.numInputBusChannels = 4;
s.options.sampleRate = 48000;
s.options.maxLogins = 8;
s.reboot;
)

// ---- SYNTHDEF ----
(
SynthDef(\es8_voice, {
    arg out = 0, amp = 0.5;
    var pitch = In.ar(9);
    var trig = In.ar(8);
    var freq = 200 + (pitch * 3000);
    var gate = Lag.ar(Schmidt.ar(trig, 0.1, 0.2), 0.005);
    Out.ar(out, SinOsc.ar(freq.clip(20, 10000)) * gate * amp);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_voice);

// ---- STOP ----
x.free;
