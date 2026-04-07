// ES-8 Noise FM — noise as FM modulator
// Pitched noise, chaotic modulation, textural hits
//
// ES-8 Input 1 (bus 8): Gate/Trigger
// ES-8 Input 2 (bus 9): V/Oct Pitch CV
// ES-8 Output 1 (bus 0): Audio out

// ---- SYNTHDEF ----
(
SynthDef(\es8_noise_fm, {
    arg out = 0, amp = 0.4;
    var pitch, trig, freq, gate;
    var noise, filtered, carrier, feedback, sig;

    pitch = In.ar(9);
    trig = In.ar(8);
    freq = 200 + (pitch * 3000);
    gate = Schmidt.ar(trig, 0.1, 0.2);

    // Bandpass filtered noise tuned to pitch
    noise = BPF.ar(WhiteNoise.ar, freq * 2, 0.05) * 20;

    // Noise as FM modulator
    carrier = SinOsc.ar(freq + (noise * freq * 3));

    // Clean sine for contrast
    filtered = SinOsc.ar(freq);

    // Resonant noise band
    feedback = BPF.ar(WhiteNoise.ar, freq, 0.01) * 40;

    sig = (carrier * 0.5) + (filtered * 0.2) + (feedback * 0.3);
    sig = sig.fold(-1, 1);
    sig = sig * gate * amp;

    Out.ar(out, sig);
}).add;
)

// ---- PLAY ----
x = Synth(\es8_noise_fm);

// ---- STOP ----
x.free;
