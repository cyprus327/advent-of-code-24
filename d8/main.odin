package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

Point :: struct {
	x: int,
	y: int
}

main :: proc() {
	data: []u8; success: bool
	data, success = os.read_entire_file("input.txt")
	if !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines: []string = strings.split_lines(string(data))

	chars: [][]u8 = make([][]u8, len(lines) - 1)
	for i in 0..<(len(lines) - 1) {
		chars[i] = make([]u8, len(lines[i]))
		for j in 0..<len(lines[i]) {
			chars[i][j] = lines[i][j]
		}
	}
	defer {
		for i in 0..<(len(lines) - 1) {
			delete(chars[i])
		}
		delete(chars)
	}

	nodes: map[Point]int = make(map[Point]int)
	defer delete(nodes)

	for l0, y0 in chars {
		for c0, x0 in l0 {
			if '.' == c0 {
				continue
			}

			for l1, y1 in chars {
				for c1, x1 in l1 {
					if (c0 != c1) || (y0 == y1 && x0 == x1) {
						continue
					}

					dx := x1 - x0
					dy := y1 - y0

					/* Part 1
					a0 := Point{x0 - dx, y0 - dy}
					if a0.x >= 0 && a0.x < len(l0) && a0.y >= 0 && a0.y < len(chars) {
						nodes[a0] += 1
					}

					a1 := Point{x1 + dx, y1 + dy}
					if a1.x >= 0 && a1.x < len(l1) && a1.y >= 0 && a1.y < len(chars) {
						nodes[a1] += 1
					}
					*/

					x, y := x0, y0
					for x >= 0 && x < len(l0) && y >= 0 && y < len(chars) {
						nodes[Point{x, y}] += 1
						x -= dx
						y -= dy
					}

					x, y = x0, y0
					for x >= 0 && x < len(l0) && y >= 0 && y < len(chars) {
						nodes[Point{x, y}] += 1
						x += dx
						y += dy
					}
				}
			}
		}
	}

	for l, y in lines {
		for c, x in l {
			p := Point{x, y}
			if 1 <= nodes[p] {
				fmt.print('.' == c ? '#' : '%')
			} else {
				fmt.print(c)
			}
		}
		fmt.println()
	}
	fmt.println(len(nodes))
}
