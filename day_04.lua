function readInput()
    local lines = {}
    local file = io.open("/uploads/input_04.txt", "r")
    for line in file:lines() do
        lines[#lines + 1] = compactWhitespaces(line:gsub("\r", ""))
    end
    file:close()
    return lines
end

function parse(input)
    local drawnNumbers = split(input[1], ",")
    local boards = {}
    local board = {}
    for i = 3, #input do
        line = input[i]
        if line == "" then
            boards[#boards + 1] = board
            board = {}
        else
            board[#board + 1] = split(trim(line), " ")
        end
    end
    boards[#boards + 1] = board
    return drawnNumbers, boards
end

function compactWhitespaces(text)
    return text:gsub("%s+", " ")
end

function trim(text)
   return text:match("^%s*(.-)%s*$")
end

function split(text, delimiter)
    parts = {}
    for part in (text..delimiter):gmatch("(.-)"..delimiter) do
        parts[#parts + 1] = part
    end
    return parts
end

function drawBoard(board)
    for row = 1, #board do
        for column = 1, #board[row] do
            io.write(board[row][column])
            io.write(" ")
        end
        io.write("\r")
    end
end

function performMove(number, board)
    local sumOfUnmarked = 0
    for row = 1, #board do
        for column = 1, #board[row] do
            if board[row][column] == number then
                board[row][column] = "x"
            end
            if board[row][column] ~= "x" then sumOfUnmarked = sumOfUnmarked + tonumber(board[row][column]) end
        end
    end

    local won = false
    local points = nil
    for row = 1, #board do
        if table.concat(board[row], "") == "xxxxx" then
            won = true
            points = sumOfUnmarked * number
            break
        end
    end
    for col = 1, #board[1] do
        if board[1][col] == "x" and board[2][col] == "x" and board[3][col] == "x" and board[4][col] == "x" and board[5][col] == "x" then
            won = true
            points = sumOfUnmarked * number
            break
        end
    end
    return won, points
end

function countNonNil(values)
    local count = 0
    for k, v in pairs(values) do
        if v ~= nil then count = count + 1 end
    end
    return count
end

function solvePuzzle1(input)
    local drawnNumbers, boards = parse(input)
    for k1, number in pairs(drawnNumbers) do
        for k2, board in pairs(boards) do
            local won, points = performMove(number, board)
            if won then
                print("points (first winner):", points) -- 2745
                return
            end
        end
    end
end

function solvePuzzle2(input)
    local drawnNumbers, boards = parse(input)
    for k1, number in pairs(drawnNumbers) do
        for k2, board in pairs(boards) do
            local won, points = performMove(number, board)
            if won then
                if countNonNil(boards) == 1 then
                    print("points (last winner):", points) -- 6594
                end
                boards[k2] = nil
            end
        end
    end
end

input = readInput()
solvePuzzle1(input)
solvePuzzle2(input)