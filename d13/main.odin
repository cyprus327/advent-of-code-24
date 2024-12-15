package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

MachineInfo :: struct {
	ax, ay, bx, by, destX, destY: int
}

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines := strings.split_lines(string(data))

	input := make([]MachineInfo, len(lines) / 4)
	defer delete(input)

	for i in 0..<len(lines) / 4 {
		j := i * 4

		axInd := strings.index_rune(lines[j + 0], 'X')
		ayInd := strings.index_rune(lines[j + 0], 'Y')
		input[i].ax = strconv.atoi(lines[j + 0][axInd + 2:ayInd - 2])
		input[i].ay = strconv.atoi(lines[j + 0][ayInd + 2:])

		bxInd := strings.index_rune(lines[j + 1], 'X')
		byInd := strings.index_rune(lines[j + 1], 'Y')
		input[i].bx = strconv.atoi(lines[j + 1][bxInd + 2:byInd - 2])
		input[i].by = strconv.atoi(lines[j + 1][byInd + 2:])

		dxInd := strings.index_rune(lines[j + 2], 'X')
		dyInd := strings.index_rune(lines[j + 2], 'Y')
		input[i].destX = strconv.atoi(lines[j + 2][dxInd + 2:dyInd - 2])
		input[i].destY = strconv.atoi(lines[j + 2][dyInd + 2:])
	}

	count := 0
	/* Part 1
	for i in 0..<len(input) {
		currMin := 9223372036854775807 // no clue if theres a math.INT_MAX or something

		ax, ay, ai := 0, 0, 0
		for ax <= input[i].destX && ay < input[i].destY {
			bx, by, bi := 0, 0, 0
			for bx <= input[i].destX && by < input[i].destY {
				if ax + bx == input[i].destX && ay + by == input[i].destY {
					currMin = min(currMin, ai * 3 + bi)
				}

				bx += input[i].bx
				by += input[i].by
				bi += 1
			}

			ax += input[i].ax
			ay += input[i].ay
			ai += 1
		}

		if 9223372036854775807 != currMin {
			count += currMin
		}
	}
	*/

	// https://en.wikipedia.org/wiki/Cramer's_rule#Explicit_formulas_for_small_systems
	for i in 0..<len(input) {
		a1, a2 := input[i].ax, input[i].ay
		b1, b2 := input[i].bx, input[i].by
		c1, c2 := input[i].destX + 10000000000000, input[i].destY + 10000000000000

		det := a1 * b2 - a2 * b1
		if 0 == det {
			continue
		}

		detX := c1 * b2 - c2 * b1
		detY := a1 * c2 - a2 * c1

		if 0 != detX % det || 0 != detY % det {
			continue
		}

		a := detX / det
		b := detY / det

		if a >= 0 && b >= 0 {
			count += a * 3 + b
		}
	}

	fmt.println(count)
}
