package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

grid: [71][71]int
visited: map[[4]u8]int
bestScore: int = 999999999

threshold := 0

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	input := strings.split_lines(string(data))
	input = input[:len(input) - 1]

	for y in 0..<len(grid) {
		for x in 0..<len(grid[y]) {
			grid[y][x] = 999999999
		}
	}

	for line, t in input {
		comma := strings.index_rune(line, ',')
		x := strconv.atoi(line[0:comma])
		y := strconv.atoi(line[comma + 1:])
		grid[y][x] = t
	}

	/* Part 1
	threshold = 1024
	score := min(try_path(0, 0, +1, 0, 0), try_path(0, 0, 0, +1, 0))
	fmt.println(score)
	*/

	low, high := 0, len(input) - 1
	for low <= high {
		threshold = low + (high - low) / 2

		clear(&visited)
		bestScore = 999999999
		score := min(try_path(0, 0, +1, 0, 0), try_path(0, 0, 0, +1, 0))

		if 999999999 == score {
			high = threshold - 1
		} else {
			low = threshold + 1
		}
	}

	outer: for a, y in grid {
		for v, x in a {
			if v == threshold {
				fmt.printfln("%d,%d", x, y)
				break outer
			}
		}
	}
}

// modified day 16 pathfinding code
try_path :: proc(x, y, dx, dy, score: int) -> int {
	if score > bestScore {
		return score
	}

	if len(grid) - 1 == y && len(grid[0]) - 1 == x {
		if score < bestScore {
			bestScore = score
		}
		return score
	}

	if threshold >= grid[y][x] {
		return 999999999
	}

	currState := [4]u8{u8(x), u8(y), u8(dx), u8(dy)}
    if prevScore, exists := visited[currState]; exists && prevScore <= score {
        return 999999999
    }
    visited[currState] = score

    currScore := 999999999

    nx, ny := x + dx, y + dy
    if ny >= 0 && ny < len(grid) && nx >= 0 && nx < len(grid[0]) && threshold < grid[ny][nx] {
    	currScore = min(currScore, try_path(nx, ny, dx, dy, score + 1))
    }

	if 0 != dy {
		if x - 1 >= 0 && threshold < grid[y][x - 1] {
			currScore = min(currScore, try_path(x, y, -1, 0, score))
		}
		if x + 1 < len(grid[0]) && threshold < grid[y][x + 1] {
			currScore = min(currScore, try_path(x, y, +1, 0, score))
		}
	}
	if 0 != dx {
		if y - 1 >= 0 && threshold < grid[y - 1][x] {
			currScore = min(currScore, try_path(x, y, 0, -1, score))
		}
		if y + 1 < len(grid) && threshold < grid[y + 1][x] {
			currScore = min(currScore, try_path(x, y, 0, +1, score))
		}
	}

	return currScore
}
