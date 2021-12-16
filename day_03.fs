// Advent of Code: Day #3 - Binary Diagnostic
// (c) 2021 TillW

open System

[<System.Runtime.CompilerServices.IsReadOnly; Struct>]
type Rates(gamma: uint32, epsilon: uint32, oxygen: uint32, co2: uint32) =
    member x.PowerConsumption = gamma * epsilon
    member x.LifeSupportRating = oxygen * co2

let countOnes(index: int, report: string seq) =
    let mutable count = 0.0
    for line in report do
        if line.[index] = '1' then count <- count + 1.0
    count

let getWordSize(report: string seq) =    
    let firstLine = Seq.head report
    firstLine.Length

let getGamma(report: string seq) =
    let mutable gamma:uint32 = 0u
    let wordSize = getWordSize report
    for column in 0 .. wordSize - 1 do
        let mcb = if countOnes(column, report) >= ((float)(Seq.length report) / 2.0) then '1' else '0'
        let factor = (uint32)(2.0 ** (float)(wordSize - column - 1))
        if mcb = '1' then gamma <- gamma + factor
    gamma

let getEpsilon(wordSize: int, gamma: uint32) =
    (~~~gamma) &&& (uint32)(~~~0u >>> (32 - wordSize))

let filterOxygenReadings(column: int, readings: string seq) =
    let mcb = if countOnes(column, readings) >= ((float)(Seq.length readings) / 2.0) then '1' else '0'
    let check(reading:string, column: int, expected: char) = reading.[column] = expected
    Seq.where(fun f -> check(f, column, mcb)) readings

let getOxygen(report: string seq) =
    let mutable relevantReadings = report
    let mutable column = 0
    while Seq.length relevantReadings > 1 do
        relevantReadings <- filterOxygenReadings(column, relevantReadings)
        column <- column + 1
    Convert.ToUInt32(Seq.head(relevantReadings), 2)

let filterCO2Readings(column: int, readings: string seq) =
        let mcb = if countOnes(column, readings) < ((float)(Seq.length readings) / 2.0) then '1' else '0'
        let check(reading:string, column: int, expected: char) = reading.[column] = expected
        Seq.where(fun f -> check(f, column, mcb)) readings

let getCO2(report: string seq) = 
    let mutable relevantReadings = report
    let mutable column = 0
    while Seq.length relevantReadings > 1 do
        relevantReadings <- filterCO2Readings(column, relevantReadings)
        column <- column + 1
    Convert.ToUInt32(Seq.head(relevantReadings), 2)

let getRates(report: string seq) =
    let gamma = getGamma report
    let epsilon = getEpsilon(getWordSize(report), gamma)
    let oxygen = getOxygen report
    let co2 = getCO2 report
    new Rates(gamma, epsilon, oxygen, co2)

let example: string seq = [| "00100"; "11110"; "10110"; "10111"; "10101"; "01111"; "00111"; "11100"; "10000"; "11001"; "00010"; "01010" |] :> string seq
let ratesExample = getRates(example)
printfn "Power consumption (example): %d" ratesExample.PowerConsumption // 198
printfn "Life support rating (example): %d" ratesExample.LifeSupportRating // 230

let input: string seq = [| "010100110111"; "101001010000"; |] :> string seq
let rates = getRates(input)
printfn "Power consumption: %d" rates.PowerConsumption
printfn "Life support rating: %d" rates.LifeSupportRating