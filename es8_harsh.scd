// ES-8 Harsh Digital Voice
// In the style of Mark Fell / Gabor Lazar
// Multi-operator FM, wavefolding, ring mod, sine clusters
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

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
SynthDef(\es8_harsh, {
    arg out = 0, amp = 0.4;

    var pitch = In.ar(9);
    var trig = In.ar(8);
    var freq = 200 + (pitch * 3000);
    var gate = Schmidt.ar(trig, 0.1, 0.2);

    // Sharp percussive envelopes — clinical transients
    var ampEnv = EnvGen.ar(Env.perc(0.001, 0.15), gate);
    var fmEnv = EnvGen.ar(Env.perc(0.0005, 0.08), gate);
    var foldEnv = EnvGen.ar(Env.perc(0.001, 0.12), gate);

    // FM operator stack — 3 operators, harsh ratios
    var op3 = SinOsc.ar(freq * 7.23) * fmEnv * freq * 3;
    var op2 = SinOsc.ar(freq * 3.01 + op3) * fmEnv * freq * 2;
    var op1 = SinOsc.ar(freq + op2);

    // Second FM voice — inharmonic metal
    var metal = SinOsc.ar(freq * 1.414 + SinOsc.ar(freq * 5.19 * fmEnv, mul: freq * 4 * fmEnv));

    // Sine cluster — tight detuned sines
    var cluster = SinOsc.ar(freq * 1.003) + SinOsc.ar(freq * 0.997) + SinOsc.ar(freq * 1.01);
    cluster = cluster * 0.33;

    // Wavefolding — digital distortion
    var folded = (op1 * (2 + (foldEnv * 6))).fold(-1, 1);

    // Ring mod between FM and cluster
    var ring = folded * cluster;

    // Mix
    var sig = (folded * 0.4) + (metal * 0.25) + (ring * 0.2) + (cluster * 0.15);

    // Hard clip — no softness
    sig = sig.clip(-0.9, 0.9);

    sig = sig * ampEnv * amp;

    Out.ar(out, sig);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_harsh);

// ---- STOP ----
x.free;
