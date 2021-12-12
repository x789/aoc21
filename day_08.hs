-- Advent of Code: Day #8 - Seven Segment Search
-- (c) 2021 TillW
import Data.List
import Data.Maybe
                       
getOutput :: String -> String
getOutput x = drop preamble x where
    preamble = ((fromJust (elemIndex '|' x)) + 2)

solvePuzzle1 :: [String] -> Int
solvePuzzle1 input = do
    let outputs = map getOutput input
    sum (map countKnownDigits outputs) where
        countKnownDigits x = sum (map (\t -> if isKnownDigit t then 1 else 0) (words x)) where
            isKnownDigit x = elem (length x) [2, 3, 4, 7]

identifyDigits :: String -> [String]
identifyDigits scrambledInput = do
    let scrambledWords = words scrambledInput
    let scrambled1 = head (filter (\x -> (length x) == 2) scrambledWords)
    let scrambled4 = head (filter (\x -> length x == 4) scrambledWords)
    let scrambled8 = head (filter (\x -> length x == 7) scrambledWords)
    let scrambled7 = head (filter (\x -> length x == 3) scrambledWords)
    let scrambled3 = head (filter (\x -> length x == 5 && length (intersect x scrambled1) == 2) scrambledWords)
    let scrambled9 = head (filter (\x -> length x == 6 && length (x \\ scrambled4) == 2) scrambledWords)
    let scrambled6 = head (filter (\x -> length x == 6 && x /= scrambled9 && length (intersect x scrambled1) == 1) scrambledWords)
    let scrambled5 = head (filter (\x -> length x == 5 && length (scrambled6 \\ x) == 1) scrambledWords)
    let scrambled2 = head (filter (\x -> length x == 5 && x /=  scrambled3 && x /= scrambled5) scrambledWords)
    let scrambled0 = head (filter (\x -> length x == 6 && x /=  scrambled6 && x /= scrambled9) scrambledWords)
    [scrambled0, scrambled1, scrambled2, scrambled3, scrambled4, scrambled5, scrambled6, scrambled7, scrambled8, scrambled9]

-- mapping table: fst = scrambled, snd = plain
createSegmentMapping :: [String] -> [(Char, Char)]
createSegmentMapping scrambledDigits = [(a, 'a'), (b, 'b'), (c, 'c'), (d, 'd'), (e, 'e'), (f, 'f'), (g, 'g')] where
    a = head (scrambledDigits!!7 \\ scrambledDigits!!1)
    b = head (scrambledDigits!!4 \\ scrambledDigits!!3)
    c = head (scrambledDigits!!1 \\ scrambledDigits!!5)
    d = head (scrambledDigits!!8 \\ scrambledDigits!!0)
    e = head (scrambledDigits!!2 \\ scrambledDigits!!3)
    f = head (scrambledDigits!!1 \\ scrambledDigits!!2)
    g = head ((scrambledDigits!!5 \\ scrambledDigits!!7) \\ scrambledDigits!!4)

segmentsToDigit :: String -> Int
segmentsToDigit segments = segmentsToDigit' (sort segments) where
    segmentsToDigit' sortedSegments | sortedSegments == "cf" = 1
                                    | sortedSegments == "acdeg" = 2
                                    | sortedSegments == "acdfg" = 3
                                    | sortedSegments == "bcdf" = 4
                                    | sortedSegments == "abdfg" = 5
                                    | sortedSegments == "abdefg" = 6
                                    | sortedSegments == "acf" = 7
                                    | sortedSegments == "abcdefg" = 8
                                    | sortedSegments == "abcdfg" = 9
                                    | otherwise = 0

solvePuzzle2 :: [String] -> Int
solvePuzzle2 [] = 0
solvePuzzle2 (x:xs) = (solvePuzzle2' x) + (solvePuzzle2 xs) where
    solvePuzzle2' line = do
        let trainingInput = take ((fromJust (elemIndex '|' line)) -1) line
        let trainingDigits = identifyDigits trainingInput
        let mappingTable = createSegmentMapping trainingDigits
        let output = getOutput line
        let outputSegments = map (\x -> descramble x mappingTable) (words output) where
            descramble scrambled mapping = map (\c -> snd c) usedEntries where
                usedEntries = map (\x -> head (filter (\y -> x == fst y) mapping)) scrambled
        let sorted = map sort outputSegments
        let digits = map segmentsToDigit sorted
        digits!!0 * 1000 + digits!!1 * 100 + digits!!2 * 10 + digits!!3
    
main = do  
    content <- readFile "/uploads/input_08.txt"
    let xs = map trim (lines content) where
        trim x | last x == '\r' = init x
               | last x /= '\r' = x

    print (solvePuzzle1 xs)
    print (solvePuzzle2 xs)