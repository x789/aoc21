// Advent of Code: Day #10 - Syntax Scoring
// (c) 2021 TillW
import haxe.Int64;

class Main {
  static public function main():Void {
    var input = sys.io.File.getContent('/uploads/input_10.txt').split('\n');
    
    var puzzle1 = new Puzzle1(input);
    trace(puzzle1.solve());
    
    var puzzle2 = new Puzzle2(input);
    trace(puzzle2.solve());
  }
}

class Puzzle1 {
    var _input:Array<String>;
    
    public function new(input:Array<String>) {
        _input = input;    
    }
    
    private function findCorruption(line:String):Int {
        var stack:String = '';
        for (i in 0...line.length) {
            var currentChar:String = line.charAt(i);
            if (isEnd(currentChar)) {
                var top:String = stack.charAt(stack.length - 1);
                if (i == 0 || !match(top, currentChar)) {
                    return i;
                }
                stack = stack.substr(0, stack.length - 1);
            } else {
                stack += currentChar;
            }
        }
        return -1;
    }
    
    private function isEnd(char:String):Bool {
        return char == ')' || char == ']' || char == '>' || char == '}';
    }
    
    private function match(start:String, end:String):Bool {
        return ((start == '(' && end == ')') || (start == '[' && end == ']') || (start == '{' && end == '}')  || (start == '<' && end == '>'));
    }
    
    private function getIllegalCharacters(input:Array<String>):String {
        var result:String = '';
        for (line in input) {
            var corruptionIndex = findCorruption(line);
            if (corruptionIndex != -1) {
                result += line.charAt(corruptionIndex);
            }
        }
        return result;
    }
    
    public function solve():Int {
        var illegalChars = getIllegalCharacters(_input);
        var score = 0;
        for (i in 0...illegalChars.length) {
            switch(illegalChars.charAt(i)) {
                case ')': score += 3;
                case ']': score += 57;
                case '}': score += 1197;
                case '>': score += 25137;
            }
        }
        return score;
    }
}

class Puzzle2 {
    var _input:Array<String>;
    
    public function new(input:Array<String>) {
        _input = input;    
    }
    
    public function solve():Int64 {
        var lineScores = new Array<Int64>();
        for (line in _input) {
            var compacted = compact(line);
            if (compacted != null) {
                var score = getLineScore(compacted);
                lineScores.push(score);
            }
        }
        lineScores.sort(Int64.compare);
        return lineScores[Std.int(lineScores.length / 2)];
    }
    
    private function isEnd(char:String):Bool {
        return char == ')' || char == ']' || char == '>' || char == '}';
    }
    
    private function match(start:String, end:String):Bool {
        return ((start == '(' && end == ')') || (start == '[' && end == ']') || (start == '{' && end == '}')  || (start == '<' && end == '>'));
    }
    
    private function compact(line:String):String {
        var stack:String = '';
        for (i in 0...line.length) {
            var currentChar:String = line.charAt(i);
            if (isEnd(currentChar)) {
                var top:String = stack.charAt(stack.length - 1);
                if (i == 0 || !match(top, currentChar)) {
                    return null;
                }
                stack = stack.substr(0, stack.length - 1);
            } else {
                stack += currentChar;
            }
        }
        return stack;
    }
    
    private function getLineScore(line:String):Int64 {
        var score = Int64.ofInt(0);
        for (i in 0...line.length) {
            score *= 5;
            score += getTerminatorScore(line.charAt(line.length - 1 - i));
        }
        return score;
    }
    
    private function getTerminatorScore(chunkStart:String):Int {
        switch(chunkStart) {
            case '(': return 1;
            case '[': return 2;
            case '{': return 3;
            case '<': return 4;
            case _: return 0;
        }
    }
}
