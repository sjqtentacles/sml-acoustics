(* demo.sml - a deterministic tour of sml-acoustics: dB/amplitude and
   dB/power round-trips, sound pressure level conversions, A/C-weighting at
   two frequencies, Sabine/Eyring reverberation time, the inverse-square law,
   and the speed of sound in air. Every value comes from a closed-form
   formula, so the output is byte-identical under MLton and Poly/ML. *)

structure A = Acoustics

fun fmtReal n r =
  let
    val s = Real.fmt (StringCvt.FIX (SOME n)) r
    val s = if String.isPrefix "~" s then "-" ^ String.extract (s, 1, NONE) else s
    val isZero = CharVector.all (fn c => c = #"0" orelse c = #"." orelse c = #"-") s
  in
    if isZero andalso String.isPrefix "-" s then String.extract (s, 1, NONE) else s
  end

val () = print "=== sml-acoustics demo ===\n\n"

val () = print "dB <-> amplitude/power round-trips:\n"
val dbA = A.dbFromAmplitude 2.0
val () = print ("  dbFromAmplitude 2.0        = " ^ fmtReal 3 dbA ^ " dB\n")
val () = print ("  amplitudeFromDb (above)    = " ^ fmtReal 3 (A.amplitudeFromDb dbA) ^ "\n")
val dbP = A.dbFromPower 2.0
val () = print ("  dbFromPower 2.0            = " ^ fmtReal 3 dbP ^ " dB\n")
val () = print ("  powerFromDb (above)        = " ^ fmtReal 3 (A.powerFromDb dbP) ^ "\n\n")

val () = print "Sound pressure level (1 Pa relative to 20 uPa reference):\n"
val spl = A.splFromPressure {pPa=1.0, prefPa=20.0e~6}
val () = print ("  splFromPressure            = " ^ fmtReal 3 spl ^ " dB SPL\n")
val () = print ("  pressureFromSpl (above)    = " ^ fmtReal 6 (A.pressureFromSpl {splDb=spl, prefPa=20.0e~6}) ^ " Pa\n\n")

val () = print "Frequency weighting (dB relative to 1 kHz):\n"
val () = print ("  aWeighting 1000.0 Hz       = " ^ fmtReal 3 (A.aWeighting 1000.0) ^ " dB\n")
val () = print ("  aWeighting 100.0 Hz        = " ^ fmtReal 3 (A.aWeighting 100.0) ^ " dB\n")
val () = print ("  cWeighting 1000.0 Hz       = " ^ fmtReal 3 (A.cWeighting 1000.0) ^ " dB\n")
val () = print ("  cWeighting 100.0 Hz        = " ^ fmtReal 3 (A.cWeighting 100.0) ^ " dB\n\n")

val () = print "Reverberation time (1000 m^3 room):\n"
val () = print ("  sabineRT60 (200 sabins)    = " ^ fmtReal 3 (A.sabineRT60 {volumeM3=1000.0, totalAbsorptionSabins=200.0}) ^ " s\n")
val () = print ("  eyringRT60 (600 m^2, a=0.2)= " ^ fmtReal 3 (A.eyringRT60 {volumeM3=1000.0, surfaceM2=600.0, avgAbsorption=0.2}) ^ " s\n\n")

val () = print "Inverse-square law and speed of sound:\n"
val () = print ("  inverseSquareSpl 90dB@1m->10m = " ^ fmtReal 3 (A.inverseSquareSpl {splRef=90.0, dRef=1.0, d=10.0}) ^ " dB\n")
val () = print ("  speedOfSoundAir 20.0 C     = " ^ fmtReal 3 (A.speedOfSoundAir 20.0) ^ " m/s\n")
