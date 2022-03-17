(* Advent of Code 2021, Day 11: Dumbo Octopus *)
(* (c) 2022 TillW *)
program day_11;
uses
  Sysutils;
type
  TPopulation = array of array of integer;
   
var
  population: TPopulation;

procedure readInput;
var
  fileIn: TextFile;
  line: string;
  col, row: integer;
begin
  setLength(population, 0);
  assignFile(fileIn, 'C:\\Users\\Till\\Documents\\aoc\\input_11.txt');
  reset(fileIn);
  while not eof(fileIn) do
  begin
    readln(fileIn, line);
    row := length(population);
    setLength(population, row+1);
    setLength(population[row], length(line));
    for col := 1 to length(line) do
      population[row][col-1] := strtoint(line[col]);
  end;
  closeFile(fileIn);
end;

procedure printPopulation;
var
  row, col: integer;
begin
  for row := 0 to length(population)-1 do
  begin
    for col := 0 to length(population[row])-1 do
      write(population[row][col]);
    writeln();
  end;
end;

procedure increaseEnergyOfPopulation;
var
  row, col: integer;
begin
  for row := 0 to length(population)-1 do
    for col := 0 to length(population[row])-1 do
      population[row][col] := population[row][col] + 1;
end;

function canFlash(): Boolean;
var
  row, col: integer;
begin
  for row := 0 to length(population)-1 do
    for col :=0 to length(population[row])-1 do
      if (population[row][col] = 10) then exit(true);
  canFlash := false;
end;

procedure increaseEnergy(row: integer; col: integer);
begin
  if ((row < 0) or (col < 0) or (row > length(population)-1) or (col > length(population[row]))) then exit();

  if ((population[row][col] > 0) and (population[row][col] < 10)) then
     population[row][col] := population[row][col]+1;
end;

procedure increaseNeighbourEnergy(row: integer; col: integer);
var
  r, c: integer;
begin
  for r := row-1 to row+1 do
    for c := col-1 to col+1 do
      increaseEnergy(r, c);
end;

function flash(): integer;
var
  row, col, numberOfFlashes: integer;
begin
  numberOfFlashes := 0;
  while canFlash() do
  begin
    for row := 0 to length(population)-1 do
      for col :=0 to length(population[row])-1 do
        if (population[row][col] = 10) then
        begin
          numberOfFlashes := numberOfFlashes+1;
          population[row][col] := 0;
          increaseNeighbourEnergy(row, col);
        end;
  end;
  flash := numberOfFlashes;
end;

procedure solvePuzzle1;
var
  step, numberOfFlashes: integer;
begin
  numberOfFlashes := 0;
  readInput();

  for step := 1 to 100 do
  begin
    increaseEnergyOfPopulation();
    numberOfFlashes := numberOfFlashes + flash();
  end;
  write('puzzle1: ');
  writeln(numberOfFlashes);
end;

function flashedSynchronously(): Boolean;
var
  row, col: Integer;
begin
  for row := 0 to length(population)-1 do
    for col :=0 to length(population[row])-1 do
      if (population[row][col] > 0) then exit(false);
  exit(true);
end;

procedure solvePuzzle2;
var
  step: integer;
begin       
  step := 0;
  readInput();
  while not flashedSynchronously() do
  begin
    increaseEnergyOfPopulation();
    flash();
    step := step+1;
  end;
  write('puzzle2: ');
  writeln(step);
end;

begin
  solvePuzzle1();
  solvePuzzle2();
end.   