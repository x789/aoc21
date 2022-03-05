# Advent of Code 2021, Day 5: Hydrothermal Venture
# (c) 2022 TillW

struct Point
    x::Int; y::Int
end

struct Line
    first::Point; last::Point
end

function getCoords(txt::AbstractString)::Point
    parts = split(txt, ",")
    Point(parse(Int,parts[1]), parse(Int,parts[2]))
end

function readInput(filename::String)
    lines = Line[]
    input = readlines(filename)
    for txtLine in input
        txtPoints = split(txtLine, " -> ");
        line = Line(getCoords(txtPoints[1]), getCoords(txtPoints[2]))
        lines = [lines;line]
    end
    lines
end

function addLine(area::Array{Int}, line::Line, ignoreDiagonal::Bool)
    if (line.first.x == line.last.x || line.first.y == line.last.y)
        for x = min(line.first.x, line.last.x):max(line.first.x, line.last.x)
            for y = min(line.first.y, line.last.y):max(line.first.y, line.last.y)
                area[x+1,y+1] += 1
            end
        end
    elseif !ignoreDiagonal
        left = line.first.x < line.last.x ? line.first : line.last
        right = left == line.last ? line.first : line.last
        slope = left.y < right.y ? 1 : -1
        for i = 0:(right.x - left.x)
            area[left.x+1+i, left.y+1+(i*slope)] += 1
        end
    end
end

function printArea(area::Array{Int})
    for i = 1:length(area)
        print(area[i] == 0 ? "." : area[i])
        if (i % size(area, 1) == 0) println() end
    end
end

function solvePuzzle(inputFilename::String, ignoreDiagonalLines::Bool)
    lines = readInput(inputFilename)
    maxx = maximum([map((e) -> e.first.x, lines); map((e) -> e.last.x, lines)])
    maxy = maximum([map((e) -> e.first.y, lines); map((e) -> e.last.y, lines)])
    area = zeros(Int, maxx+1, maxy+1)
    for line in lines
        addLine(area, line, ignoreDiagonalLines)
    end
    count((x) -> x > 1, area)
end

function solvePuzzle1(inputFileName::String) solvePuzzle(inputFileName, true) end
function solvePuzzle2(inputFileName::String) solvePuzzle(inputFileName, false) end

print("Number of overlaps: ")
print(solvePuzzle1("input_05.txt"))
print("/")
println(solvePuzzle2("input_05.txt"))