// Advent of Code: Day #7 - The Treachery of Whales
// (c) 2021 TillW

fun solvePuzzle(costCalculation: (usedFuel: Int) -> Int): Int {
    val input = "16,1,2,0,4,2,7,1,2,14".split(",")
    val numbers = input.map{ s -> s.toInt() }.toIntArray()
    var lowestFuelConsumption = Int.MAX_VALUE
    for (target in 0..(numbers.maxOrNull() ?: 0)) {
        var usedFuel = 0
        numbers.forEach {
            usedFuel += costCalculation(Math.abs(it - target))
        }
        
        if (lowestFuelConsumption > usedFuel) {
            lowestFuelConsumption = usedFuel
        }
    }
    
    return lowestFuelConsumption
}

fun main() {
    val usedFuel1 = solvePuzzle({ it })
    println("Lowest fuel consumption (puzzle 1): ${usedFuel1}")
    val usedFuel2 = solvePuzzle({ (0..it).sum() })
    println("Lowest fuel consumption (puzzle 2): ${usedFuel2}")
}