// Advent of Code: Day #9 - Smoke Basin
// (c) 2021 TillW

import std.stdio, std.file, std.array, std.conv, std.range, std.string, std.algorithm;

class HeightMap {
    private int[] buffer;
    private uint width;
    
    this(uint width, string data) {
        this.width = width;
        buffer = new int[data.length];
        for (int y = 0; y < buffer.length; y++) {
            buffer[y] = to!int([data[y]]);
        }
    }
    
    uint getSumOfRiskLevels() {
        auto totalRiskLevel = 0u;
        auto chunks = chunks(buffer, width);
        for (int r = 0; r < chunks.length; r++) {
            for (int c = 0; c < chunks[r].length; c++) {
                auto top = r == 0 ? 10 : chunks[r-1][c];
                auto right = c == chunks[r].length - 1 ? 10 : chunks[r][c+1];
                auto bottom = r == chunks.length -1 ? 10 : chunks[r+1][c];
                auto left = c == 0 ? 10 : chunks[r][c-1];
                auto current = chunks[r][c];
                if (current < top && current < left && current < bottom && current < right) {
                    auto localRiskLevel = current + 1;
                    totalRiskLevel += localRiskLevel;
                }
            }
        }
        return totalRiskLevel;
    }
    
    uint calculateBasinSize(int col, int row, uint size, int[] data) {
        auto chunks = chunks(data, width);
        if (col < 0 || row < 0 || col == width || row == chunks.length || chunks[row][col] == 9) return size;
        chunks[row][col] = 9;
        size += 1;
        size = calculateBasinSize(col, row-1, size, data);
        size = calculateBasinSize(col, row+1, size, data);
        size = calculateBasinSize(col-1, row, size, data);
        size = calculateBasinSize(col+1, row, size, data);
        return size;
    }
    
    uint[] getBasinSizes() {
        auto data = this.buffer.dup();
        auto sizes = new uint[0];
        for (int i = 0; i < data.length; i++) {
            if (data[i] != 9) {
                auto basinSize = calculateBasinSize(i % width, i / width, 0u, data);
                sizes ~= [basinSize];
            }
        }
        sizes.sort();
        return sizes;
    }
}

void main(string[ ] args) {
    auto fileContent = readText("/uploads/input_09.txt");
    auto width = cast(uint)indexOf(fileContent, "\r");
    auto map = new HeightMap(width, fileContent.replace("\r\n", ""));
    writeln("total risk level: ", map.getSumOfRiskLevels());
    auto basinSizes = map.getBasinSizes();
    writeln("sizes of the three largest basins: ", basinSizes[basinSizes.length -1] * basinSizes[basinSizes.length -2] * basinSizes[basinSizes.length -3]);
}