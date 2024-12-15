package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

Point :: struct {
	x, y: int
}

lines: [dynamic]string
visited: map[Point]bool

dirX, dirY := []int{ -1, 1, 0, 0 }, []int{ 0, 0, -1, 1 }

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	split := strings.split_lines(string(data))
	split = split[:len(split) - 1]

	append(&lines, strings.repeat("#", len(split[0]) + 2))
	for line, lineNum in split {
		append(&lines, strings.concatenate({"#", line, "#"}))
	}
	append(&lines, lines[0])

	visited = make(map[Point]bool)
	defer delete(visited)

	part1, part2 := 0, 0
	for line, lineNum in lines {
		for char, charInd in line {
			p := Point{charInd, lineNum}
			if '#' == char {
				visited[p] = true
				continue
			}

			if _, exists := visited[p]; exists {
				continue
			}

			area, perimeter, sides := 0, 0, 0
			flood_fill(p, u8(char), &area, &perimeter, &sides)

			part1 += area * perimeter

			part2 += area * sides
		}
	}

	fmt.println(part1, part2)
}

flood_fill :: proc(p: Point, target: u8, area, perimeter, sides: ^int) {
	if p.y < 0 || p.x < 0 || p.y >= len(lines) || p.x >= len(lines[p.y]) {
		perimeter^ += 1
		return
	}

	if lines[p.y][p.x] != target {
		perimeter^ += 1
		return
	}

	if _, exists := visited[p]; exists {
		return
	}

	visited[p] = true
	area^ += 1

	sides^ += is_corner(p)

	for i in 0..<4 {
		flood_fill(Point{p.x + dirX[i], p.y + dirY[i]}, target, area, perimeter, sides)
	}
}

is_corner :: proc(p: Point) -> int {
	t := lines[p.y][p.x]
	count := 0

	if lines[p.y + 1][p.x] != t && lines[p.y][p.x + 1] != t {
		count += 1
	}
	if lines[p.y + 1][p.x] != t && lines[p.y][p.x - 1] != t {
		count += 1
	}
	if lines[p.y - 1][p.x] != t && lines[p.y][p.x + 1] != t {
		count += 1
	}
	if lines[p.y - 1][p.x] != t && lines[p.y][p.x - 1] != t {
		count += 1
	}

	if lines[p.y + 1][p.x] == t && lines[p.y][p.x + 1] == t && lines[p.y + 1][p.x + 1] != t {
		count += 1
	}
	if lines[p.y + 1][p.x] == t && lines[p.y][p.x - 1] == t && lines[p.y + 1][p.x - 1] != t {
		count += 1
	}
	if lines[p.y - 1][p.x] == t && lines[p.y][p.x + 1] == t && lines[p.y - 1][p.x + 1] != t {
		count += 1
	}
	if lines[p.y - 1][p.x] == t && lines[p.y][p.x - 1] == t && lines[p.y - 1][p.x - 1] != t {
		count += 1
	}

	return count
}
