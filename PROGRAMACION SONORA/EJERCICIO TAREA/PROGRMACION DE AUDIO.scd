// Inicializa el servidor y espera a que esté listo
s.waitForBoot {
    // Define la ruta del archivo de audio
    var path = "/Users/DELL/Downloads/aud 1.wav";

    // Cargar el archivo de audio en un buffer
    ~buffer = Buffer.read(s, path);

    // Define el SynthDef para reproducir el buffer
    SynthDef(\samplePlayer, { |out = 0, rate = 1, amp = 0.8, sus = 1, rel = 1|
        var sig = PlayBuf.ar(2, ~buffer.bufnum, BufRateScale.kr(~buffer.bufnum) * rate, loop: 0);
        sig = sig * EnvGen.kr(Env.perc(sus, rel), doneAction: 2);
        Out.ar(out, sig * amp);
    }).add;

    "Buffer and SynthDef loaded.".postln;

    // Define la secuencia Pdef
    (
    ~sampleSeq = Pdef(\sampleSeq, Pbind(
        \instrument, \samplePlayer,
        \dur, Pseq([1/4, 1/2, 1/8, 1/4], inf),  // Duraciones variadas
        \amp, Pseq([0.5, 0.8, 0.6, 1.0], inf),   // Diferentes niveles de amplificación
        \rate, Pseq([1, 0.8, 1.2, 1], inf),      // Velocidad de reproducción
        \sus, Pseq([0.2, 0.4, 0.1, 0.3], inf),   // Sostenimiento
        \rel, Pseq([0.1, 0.2, 0.1, 0.2], inf)    // Liberación
    ));
    );

    // Establece el tempo
    TempoClock.default.tempo = 60 / 120;

    // Reproduce la secuencia
    ~sampleSeq.play.quant(4);

    // Código para detener la secuencia después de 10 segundos (opcional)
    Routine({
        10.wait;
        ~sampleSeq.stop;
        "Sequence stopped.".postln;
    }).play;
};