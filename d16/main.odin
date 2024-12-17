package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

maze: []string
visited: map[[4]u8]int

bestPathPoints: map[[2]u8]bool
bestScore: int = 83444

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	maze = strings.split_lines(string(data))
	maze = maze[0:len(maze) - 1]

	visited = make(map[[4]u8]int)
	defer delete(visited)

	bestPathPoints = make(map[[2]u8]bool)
	defer delete(bestPathPoints)

	sx, sy := -1, -1
	outer: for line, y in maze {
		for char, x in line {
			if 'S' != char {
				continue
			}

			sx, sy = x, y
			break outer
		}
	}

	bestScore = try_path(sx, sy, +1, 0, 0)

	clear(&visited)

	try_path(sx, sy, +1, 0, 0)

	fmt.println(bestScore, len(bestPathPoints))
}

try_path :: proc(x, y, dx, dy, score: int) -> int {
	if score > bestScore {
		return score
	}

	if 'E' == maze[y][x] {
		fmt.println("END", score, bestScore)
		if score < bestScore {
			bestScore = score
			clear(&bestPathPoints)
		}
		return score
	}

	if '#' == maze[y][x] {
		return 999999999
	}

	// the +2000 makes it insanely slow but is the only
	// way I could think of to make it find all possible paths
	currState := [4]u8{u8(x), u8(y), u8(dx), u8(dy)}
    if prevScore, exists := visited[currState]; exists && prevScore + 2000 <= score {
        return 999999999
    }
    visited[currState] = score

    currScore := min(999999999, try_path(x + dx, y + dy, dx, dy, score + 1))
    if currScore == bestScore {
    	bestPathPoints[{u8(x + dx), u8(y + dy)}] = true
    }

	if 0 != dy {
		if '#' != maze[y][x - 1] {
			currScore = min(currScore, try_path(x, y, -1, 0, score + 1000))
		    if currScore == bestScore {
		    	bestPathPoints[{u8(x), u8(y)}] = true
		    }
		}
		if '#' != maze[y][x + 1] {
			currScore = min(currScore, try_path(x, y, +1, 0, score + 1000))
		    if currScore == bestScore {
		    	bestPathPoints[{u8(x), u8(y)}] = true
		    }
		}
	}
	if 0 != dx {
		if '#' != maze[y - 1][x] {
			currScore = min(currScore, try_path(x, y, 0, -1, score + 1000))
		    if currScore == bestScore {
		    	bestPathPoints[{u8(x), u8(y)}] = true
		    }
		}
		if '#' != maze[y + 1][x] {
			currScore = min(currScore, try_path(x, y, 0, +1, score + 1000))
		    if currScore == bestScore {
		    	bestPathPoints[{u8(x), u8(y)}] = true
		    }
		}
	}

	return currScore
}
