// Advent of Code 2021: Day #2 - Dive!
// (c) 2021 TillW

trait SubmarineControl {
  def move(command: String): Unit
  var horizontal: Int
  var depth: Int
}

class Submarine(var horizontal: Int = 0, var depth: Int = 0) extends SubmarineControl {
  def move(command: String): Unit = {
    var parts = command.split(" ")
    var direction = parts(0)
    var x = parts(1).toInt
    horizontal = direction match
      case "forward" => horizontal + x
      case _ => horizontal
    depth = direction match
      case "down" => depth + x
      case "up" => depth - x
      case _ => depth
  }
}

class Submarine2(var horizontal: Int = 0, var depth: Int = 0, var aim: Int = 0) extends SubmarineControl {
  def move(command: String): Unit = {
    var parts = command.split(" ")
    var direction = parts(0)
    var x = parts(1).toInt
    if (direction == "forward") {
      horizontal += x
      depth += aim * x
    } else if (direction == "down") {
      aim += x
    } else if (direction == "up") {
      aim -= x
    }
  }
}

object Program {
  var example = "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2".split("\n")
  var input = "forward 1\ndown 6\nforward 8\nup 3\ndown 1\ndown 4\ndown 7\ndown 3\ndown 6\nup 8\ndown 3\nforward 8\nup 4\nforward 8\nup 5\ndown 3\nup 2\nforward 3\nforward 1\nforward 1\nup 4\ndown 6\nforward 5\ndown 7\ndown 1\ndown 5\ndown 6\nup 5\ndown 2\nforward 7\ndown 9\nforward 5\nup 6\nforward 2\ndown 2\ndown 2\ndown 1\nforward 6\nforward 8\nup 5\ndown 6\ndown 7\nforward 5\nup 7\ndown 9\ndown 9\ndown 3\ndown 3\nforward 1\ndown 2\nup 8\ndown 1\ndown 7\ndown 4\nforward 6\nup 8\nup 8\nup 5\nup 4\ndown 9\nforward 4\ndown 3\ndown 8\nup 8\nup 7\ndown 3\nforward 2\nforward 3\nforward 4\nforward 9\nup 2\nforward 9\nup 5\nup 9\ndown 9\nforward 2\ndown 7\ndown 2\nforward 7\ndown 3\ndown 9\ndown 8\nup 3\nup 4\ndown 8\ndown 8\nup 7\nup 7\nup 2\nup 9\nup 6\nforward 7\nforward 9\nforward 1\nup 9\ndown 2\nforward 9\ndown 6\nforward 6\ndown 5\nup 2\nforward 5\nforward 2\ndown 6\ndown 3\nforward 4\nup 9\ndown 8\ndown 1\ndown 9\ndown 2\ndown 5\nforward 6\nforward 2\nforward 4\ndown 5\ndown 8\nforward 2\nforward 1\nforward 3\nforward 4\nup 4\nforward 7\ndown 4\nup 1\nup 2\ndown 5\ndown 7\nup 3\nforward 6\nup 2\ndown 1\ndown 4\ndown 3\nforward 8\nforward 4\ndown 7\nup 8\ndown 8\ndown 1\nforward 9\ndown 3\nforward 1\ndown 2\nup 4\ndown 4\ndown 5\nup 3\nup 1\nup 2\nforward 7\nforward 4\nforward 3\ndown 4\nforward 7\nforward 7\nforward 8\nforward 9\ndown 7\nforward 9\nforward 8\nup 2\nup 9\nforward 3\nforward 1\ndown 3\nforward 3\nup 7\nup 1\nforward 4\ndown 1\nup 9\nup 2\ndown 9\nforward 4\nforward 7\ndown 2\nforward 7\nforward 6\nup 7\nforward 8\nup 7\nup 2\ndown 8\ndown 6\ndown 6\nforward 7\ndown 8\ndown 1\nforward 3\ndown 1\ndown 9\nforward 5\nup 1\nforward 6\nup 8\ndown 1\nforward 4\nforward 6\nup 4\nup 8\nforward 5\nforward 4\nforward 7\ndown 2\nup 6\nforward 7\nforward 1\nforward 5\ndown 6\nforward 3\nforward 4\nforward 2\nforward 8\ndown 5\nforward 2\nup 3\nforward 2\nforward 4\nup 2\ndown 5\ndown 5\nforward 4\nforward 1\ndown 1\nup 9\nforward 4\nforward 9\nup 4\nup 4\nforward 6\ndown 6\nforward 6\nforward 7\ndown 2\nforward 8\nforward 6\ndown 4\ndown 3\ndown 5\ndown 5\nup 2\ndown 6\nup 5\nup 4\ndown 8\ndown 7\ndown 9\ndown 7\nforward 5\nup 5\nforward 4\nforward 8\ndown 4\nup 4\nup 7\nforward 8\nup 4\nup 2\nforward 6\nup 3\ndown 1\nforward 6\nforward 3\nup 2\nforward 2\nforward 8\nforward 8\nforward 2\ndown 9\ndown 4\nforward 8\nforward 9\ndown 3\nforward 5\nup 7\ndown 6\nup 2\nup 6\nup 8\nforward 7\ndown 1\nup 7\ndown 7\nforward 1\nforward 5\nforward 4\ndown 8\nforward 4\ndown 8\nforward 1\ndown 7\ndown 8\nforward 1\nforward 2\ndown 3\ndown 3\nup 4\nforward 7\ndown 2\nforward 9\nup 8\ndown 1\nforward 5\nforward 6\nforward 5\nforward 3\ndown 6\ndown 1\nup 4\ndown 9\nforward 8\nup 2\ndown 5\nforward 1\nup 2\ndown 8\ndown 9\nforward 6\nup 8\ndown 5\ndown 5\ndown 7\nup 6\nup 4\nup 3\nup 7\nup 3\ndown 5\nforward 9\nup 6\ndown 1\ndown 8\ndown 8\nforward 9\nforward 3\nforward 7\nforward 3\nforward 1\nup 7\ndown 3\ndown 6\nforward 8\nup 5\nforward 6\ndown 6\nforward 3\ndown 1\nup 8\nforward 5\nforward 9\nup 1\nup 1\nforward 9\nup 1\nforward 4\nforward 1\nforward 7\ndown 6\nup 1\nforward 4\nup 7\ndown 2\ndown 1\nforward 2\nup 4\nforward 3\ndown 4\nup 7\ndown 9\ndown 9\nforward 8\ndown 4\nup 7\ndown 4\nforward 2\nup 7\nforward 2\nforward 4\ndown 5\nforward 4\ndown 6\nforward 9\nforward 1\nforward 5\nforward 7\nup 5\ndown 9\ndown 5\ndown 5\nup 7\nforward 7\nforward 6\nup 7\nforward 8\nup 2\nforward 5\ndown 9\nup 3\ndown 5\nforward 4\ndown 7\nup 8\nup 8\ndown 3\ndown 2\ndown 7\ndown 9\nforward 6\nforward 9\nforward 9\nforward 2\ndown 2\nforward 4\nforward 7\nup 2\nup 5\nforward 8\ndown 1\ndown 1\ndown 9\ndown 2\nforward 1\nup 5\nforward 6\ndown 1\nforward 8\nup 2\nup 4\ndown 3\nforward 6\nforward 3\ndown 4\nforward 9\ndown 6\ndown 9\nup 2\ndown 4\ndown 6\nforward 3\nup 4\ndown 4\nup 9\nforward 4\nforward 9\nforward 2\nforward 8\ndown 9\nup 5\nforward 8\ndown 1\nforward 8\nup 1\ndown 1\nforward 7\nup 6\ndown 2\nup 1\ndown 8\ndown 4\nforward 3\ndown 3\nforward 6\nforward 1\nforward 9\ndown 5\ndown 9\ndown 6\ndown 2\nforward 4\ndown 6\ndown 5\nup 3\nup 1\ndown 8\nforward 7\nforward 5\ndown 8\ndown 4\ndown 2\nforward 5\nforward 2\nforward 5\ndown 5\nforward 7\ndown 9\ndown 1\nforward 2\ndown 4\ndown 1\nforward 6\nup 2\nup 6\nforward 7\ndown 1\nup 5\ndown 6\nforward 3\nup 3\nforward 5\nforward 5\ndown 4\nforward 4\ndown 8\ndown 2\nup 3\nup 4\ndown 9\nup 5\ndown 6\nforward 6\nforward 6\nup 9\nup 2\nforward 3\ndown 5\ndown 9\nforward 2\nup 3\nforward 7\nforward 1\nup 9\ndown 8\nup 9\nforward 4\nforward 4\nforward 8\ndown 4\ndown 2\ndown 5\ndown 7\ndown 9\nup 2\ndown 1\nforward 7\ndown 4\ndown 1\nforward 2\ndown 3\nup 5\nup 1\ndown 3\ndown 4\nup 4\ndown 7\nforward 6\nforward 3\nforward 4\ndown 5\nup 3\nup 9\nforward 2\ndown 8\nup 2\ndown 7\ndown 2\nup 3\nforward 5\nforward 7\nup 4\ndown 3\ndown 1\nforward 5\nforward 2\nup 3\nup 6\nforward 8\ndown 5\nforward 5\ndown 7\ndown 5\nup 7\ndown 8\nforward 5\ndown 9\nup 5\nforward 8\nforward 6\nforward 7\ndown 9\nup 9\nforward 3\ndown 8\nforward 1\nforward 5\nforward 9\ndown 9\ndown 2\ndown 6\ndown 7\nforward 8\ndown 6\ndown 8\nup 8\ndown 2\nforward 2\nup 5\nup 3\ndown 1\ndown 7\ndown 6\nforward 4\nup 5\nforward 6\nup 8\nforward 3\nup 6\nforward 3\ndown 5\nforward 8\nforward 8\nup 6\nforward 5\ndown 4\ndown 7\ndown 5\ndown 9\nforward 2\nforward 9\ndown 9\nforward 8\ndown 4\nforward 4\nforward 1\ndown 8\ndown 1\ndown 9\ndown 5\nforward 4\nup 6\ndown 7\ndown 1\nup 4\ndown 4\ndown 6\ndown 4\nup 8\ndown 2\nforward 1\nforward 4\ndown 1\ndown 1\nup 2\nforward 5\nup 5\ndown 9\nforward 3\ndown 3\nforward 6\nforward 4\ndown 6\nforward 2\nup 7\nup 8\nup 2\nup 8\nup 8\ndown 8\nforward 4\ndown 1\nforward 2\nforward 9\nup 3\ndown 2\ndown 1\nup 4\ndown 9\ndown 6\nforward 9\ndown 6\ndown 8\ndown 9\nforward 2\nup 7\nforward 1\ndown 8\ndown 7\ndown 8\nup 3\nforward 3\nup 7\nforward 7\ndown 9\ndown 3\ndown 2\ndown 5\nforward 9\nup 1\ndown 7\nforward 5\nforward 4\nforward 8\nup 6\ndown 7\nforward 5\nup 5\ndown 1\nforward 4\nforward 9\ndown 2\nforward 8\nup 9\ndown 8\nforward 8\nup 6\nforward 3\nforward 1\nup 5\ndown 6\nforward 8\nup 7\ndown 1\ndown 7\ndown 3\nforward 7\ndown 9\ndown 5\ndown 2\nforward 2\ndown 4\ndown 1\nforward 8\ndown 4\nup 1\nforward 4\ndown 7\nforward 6\ndown 5\nup 8\nforward 1\nforward 2\nup 5\ndown 7\nforward 6\ndown 7\nforward 6\ndown 8\ndown 2\nup 3\ndown 6\nforward 1\ndown 5\ndown 8\ndown 2\nforward 6\nup 4\nforward 4\ndown 1\nforward 9\nforward 8\nforward 4\nforward 9\ndown 8\ndown 8\nup 1\nup 3\ndown 8\ndown 4\nforward 4\ndown 6\nup 7\ndown 8\ndown 3\ndown 2\ndown 7\ndown 5\ndown 7\nforward 3\ndown 6\nforward 6\ndown 1\nforward 7\ndown 9\nforward 2\ndown 7\nforward 1\nup 9\ndown 5\nup 6\ndown 2\nup 4\nforward 5\nforward 2\nforward 6\ndown 2\nforward 5\ndown 3\nforward 6\nup 7\nup 5\nup 3\nup 5\nup 4\ndown 8\nup 8\nforward 3\ndown 2\ndown 1\nforward 2\ndown 8\ndown 8\ndown 1\nup 7\ndown 1\nforward 6\ndown 5\nforward 7\nup 3\nup 4\nforward 9\ndown 3\ndown 1\ndown 6\nforward 1\nforward 6\nforward 2\nforward 5\ndown 7\ndown 5\ndown 2\nforward 6\ndown 7\nforward 2\ndown 4\ndown 8\nforward 2\nforward 2\nup 5\nforward 5\ndown 5\ndown 4\nup 7\ndown 3\nforward 2\ndown 7\nforward 2\nforward 5\ndown 8\nup 3\nforward 4\nforward 4\ndown 2\ndown 9\ndown 5\nforward 2\nforward 7\ndown 7\ndown 1\ndown 5\ndown 1\ndown 4\ndown 9\ndown 2\nforward 9\nforward 8\ndown 4\nforward 9\ndown 9\ndown 7\ndown 6\ndown 2\nforward 5\ndown 4\nup 3\nforward 2\nup 5\nforward 7\nup 6\nforward 3\nforward 1\nforward 3\ndown 7\nforward 8\ndown 1\nforward 1\nforward 5\nforward 5\nup 4\ndown 7\ndown 8\nforward 4\ndown 6\nforward 1\nforward 7\ndown 5\ndown 9\nforward 2\ndown 3\ndown 5\nforward 4\nforward 5\nforward 1\ndown 1\ndown 6\ndown 9\nforward 1\nforward 1\nup 5\nforward 3\nup 3\nup 5\ndown 2\nforward 6\nforward 3\ndown 4\nup 3\ndown 8\ndown 4\nup 3\ndown 7\nforward 7\nup 3\ndown 3\ndown 8\ndown 4\ndown 5\ndown 3\nup 1\nforward 4\nforward 1\ndown 5\nup 8\nup 9\nforward 1\nup 8\ndown 3\nforward 8\nup 4\nforward 5\nforward 5\nup 1\ndown 6\ndown 2\nup 3\nup 7\nforward 7\ndown 7\nup 9\nforward 2\nforward 8\nforward 2\nup 7\nforward 3\ndown 8\ndown 7\nforward 6\ndown 9\nforward 4\nforward 9\nforward 2\ndown 2\ndown 6\ndown 8\nforward 6\ndown 5\nforward 7\nup 8\ndown 6\nforward 5\ndown 6\nforward 1\nforward 5\nforward 1\nup 9\nforward 3\ndown 9\ndown 7\nforward 3\nup 6\ndown 9\ndown 6\ndown 9\nforward 3\nforward 5\nup 3\nup 9\ndown 1\ndown 8\ndown 4\nforward 6\ndown 9\nforward 4\nforward 3\ndown 8\nforward 5\nforward 6\nforward 5\nforward 1\nforward 7\nforward 8\ndown 4\nforward 9\nup 3\ndown 3\nforward 6\ndown 2\nforward 7\ndown 2\nforward 8\nforward 3".split("\n")
  
  def solvePuzzle(submarine: SubmarineControl, input: Array[String]): Unit = {
    println()
    println(s"Solving puzzle...")
    input.foreach(command => submarine.move(command))
    
    println("Horizontal: " + submarine.horizontal)
    println("Depth: " + submarine.depth)
    println("Answer: " + submarine.horizontal * submarine.depth)
  }
  
  def main(args: Array[String]): Unit = {
    solvePuzzle(new Submarine(), example) // 150
    solvePuzzle(new Submarine(), input) // 1714950
    solvePuzzle(new Submarine(), example) // 900
    solvePuzzle(new Submarine2(), input) // 1281977850
  }
}