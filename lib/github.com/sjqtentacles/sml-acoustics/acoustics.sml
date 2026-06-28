structure Acoustics :> ACOUSTICS =
struct
  fun log10 x = Math.ln x / Math.ln 10.0

  fun dbFromAmplitude r = 20.0 * log10 r
  fun amplitudeFromDb d = Math.pow (10.0, d / 20.0)
  fun dbFromPower     r = 10.0 * log10 r
  fun powerFromDb     d = Math.pow (10.0, d / 10.0)

  fun splFromPressure {pPa, prefPa} = 20.0 * log10 (pPa / prefPa)
  fun pressureFromSpl {splDb, prefPa} = prefPa * Math.pow (10.0, splDb / 20.0)

  (* A-weighting per IEC 61672 *)
  fun aWeightingLinear f =
    let
      val f2 = f * f
      val k  = 12200.0 * 12200.0 * f2 * f2
      val d1 = f2 + 20.6 * 20.6
      val d2 = Math.sqrt ((f2 + 107.7*107.7) * (f2 + 737.9*737.9))
      val d3 = f2 + 12200.0 * 12200.0
    in k / (d1 * d2 * d3) end

  val aRef = aWeightingLinear 1000.0

  fun aWeighting f = 20.0 * log10 (aWeightingLinear f / aRef)

  (* C-weighting per IEC 61672 *)
  fun cWeightingLinear f =
    let
      val f2 = f * f
      val k  = 12200.0 * 12200.0 * f2
      val d1 = f2 + 20.6 * 20.6
      val d2 = f2 + 12200.0 * 12200.0
    in k / (d1 * d2) end

  val cRef = cWeightingLinear 1000.0

  fun cWeighting f = 20.0 * log10 (cWeightingLinear f / cRef)

  fun sabineRT60 {volumeM3, totalAbsorptionSabins} =
    0.161 * volumeM3 / totalAbsorptionSabins

  fun eyringRT60 {volumeM3, surfaceM2, avgAbsorption} =
    0.161 * volumeM3 / (~surfaceM2 * Math.ln (1.0 - avgAbsorption))

  fun inverseSquareSpl {splRef, dRef, d} =
    splRef - 20.0 * log10 (d / dRef)

  fun speedOfSoundAir tC = 331.3 * Math.sqrt (1.0 + tC / 273.15)
end
