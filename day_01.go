// Advent of Code: Day #1 - Sonar Sweep
// (c) 2021 TillW

package main

import "testing"

type Sonar struct {
	LastReading  int
	InstanceUsed bool
}

func (sonar *Sonar) AddReading(reading int) (res int) {
	diff := sonar.LastReading - reading
	sonar.LastReading = reading
	if !sonar.InstanceUsed {
		sonar.InstanceUsed = true
		return 0
	}
	if diff < 0 {
		return 1
	} else if diff > 0 {
		return -1
	} else {
		return 0
	}
}

func FindNumberOfIncreasements(readings []int) (res int) {
	sonar := new(Sonar)
	increasements := 0
	for i := 0; i < len(readings); i++ {
		if sonar.AddReading(readings[i]) > 0 {
			increasements = increasements + 1
		}
	}
	return increasements
}

var readings = []int{171, 173, 174, 163}

func TestSolvePuzzle1(t *testing.T) {
	increasements := FindNumberOfIncreasements(readings)

	AssertEqual(t, 1266, increasements)
}

func TestSolvePuzzle2(t *testing.T) {
	// Calculate window-sums to re-use the Sonar from puzzle 1.
	windows := make([]int, len(readings)-2)
	for i := 0; i < len(windows); i++ {
		windows[i] = readings[i] + readings[i+1] + readings[i+2]
	}

	increasements := FindNumberOfIncreasements(windows)

	AssertEqual(t, 1217, increasements)
}

func TestExample(t *testing.T) {
	sonar := new(Sonar)
	AssertEqual(t, 0, sonar.AddReading(199))
	AssertEqual(t, 1, sonar.AddReading(200))
	AssertEqual(t, 1, sonar.AddReading(208))
	AssertEqual(t, 1, sonar.AddReading(210))
	AssertEqual(t, -1, sonar.AddReading(200))
	AssertEqual(t, 1, sonar.AddReading(207))
	AssertEqual(t, 1, sonar.AddReading(240))
	AssertEqual(t, 1, sonar.AddReading(269))
	AssertEqual(t, -1, sonar.AddReading(260))
	AssertEqual(t, 1, sonar.AddReading(263))
}

func AssertEqual(t *testing.T, expected int, actual int) {
	if actual != expected {
		t.Errorf("actual '%d' != expected '%d'", actual, expected)
	}
}

