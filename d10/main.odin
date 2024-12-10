package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

Point :: struct {
	ox, oy, x, y: int
}

points: map[Point]int

lines: []string

main :: proc() {
	data: []u8; success: bool
	data, success = os.read_entire_file("input.txt")
	if !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines = strings.split_lines(string(data))
	lines = lines[0:len(lines) - 1]

	points = make(map[Point]int)
	defer delete(points)

	scoreSum := 0
	for line, lineNum in lines {
		for char, charInd in line {
			if '0' != char {
				continue
			}

			score := 0
			score += search_path(charInd, lineNum, charInd, lineNum, -1,  0)
			score += search_path(charInd, lineNum, charInd, lineNum,  1,  0)
			score += search_path(charInd, lineNum, charInd, lineNum,  0, -1)
			score += search_path(charInd, lineNum, charInd, lineNum,  0,  1)
			scoreSum += score
		}
	}

	// 			Part 1		 Part 2
	fmt.println(len(points), scoreSum)
}

search_path :: proc(ox, oy, sx, sy, dx, dy: int) -> int {
	x, y := sx + dx, sy + dy
	if x < 0 || y < 0 || x >= len(lines[0]) || y >= len(lines) {
		return 0
	}

	if 1 != lines[y][x] - lines[sy][sx] {
		return 0
	}

	if lines[y][x] == '9' {
		points[Point{ox, oy, x, y}] += 1 // for Part 1
		return 1						 // for Part 2
	}

	return search_path(ox, oy, x, y, -1,  0) +
			search_path(ox, oy, x, y, 1,  0) +
			search_path(ox, oy, x, y, 0, -1) +
			search_path(ox, oy, x, y, 0,  1)
}
