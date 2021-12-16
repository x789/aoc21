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
    horizontal = direction match {
      case "forward" => horizontal + x
      case _ => horizontal
    }
    depth = direction match {
      case "down" => depth + x
      case "up" => depth - x
      case _ => depth
    }
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
  var input = "forward 1\ndown 6\nforward 8\nup 3".split("\n")
  
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
    solvePuzzle(new Submarine(), input)
    solvePuzzle(new Submarine2(), example) // 900
    solvePuzzle(new Submarine2(), input)
  }
}