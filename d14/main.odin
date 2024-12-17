package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

Bot :: struct {
	x, y, vx, vy: int
}

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines := strings.split_lines(string(data))
	lines = lines[0:len(lines) - 1]

	bots := make([dynamic]Bot)
	defer delete(bots)

	world: [103][101]int

	for line in lines {
		split := strings.split(line, " ")

		pxInd := strings.index_rune(split[0], '=') + 1
		pyInd := strings.index_rune(split[0], ',') + 1
		vxInd := strings.index_rune(split[1], '=') + 1
		vyInd := strings.index_rune(split[1], ',') + 1

		x := strconv.atoi(split[0][pxInd:pyInd - 1])
		y := strconv.atoi(split[0][pyInd:])
		vx := strconv.atoi(split[1][vxInd:vyInd - 1])
		vy := strconv.atoi(split[1][vyInd:])

		world[y][x] += 1

		append(&bots, Bot{ x = x, y = y, vx = vx, vy = vy })
	}

	/* Part 1
	for i in 0..<100 {
		for &bot in bots {
			world[bot.y][bot.x] -= 1
			nx := (bot.x + bot.vx) % len(world[0])
			ny := (bot.y + bot.vy) % len(world)
			bot.x = nx < 0 ? len(world[0]) + nx : nx
			bot.y = ny < 0 ? len(world) + ny : ny
			world[bot.y][bot.x] += 1
		}
	}

	q0, q1, q2, q3 := 0, 0, 0, 0
	for y in 0..<len(world) {
		qy := y - len(world) / 2
		if 0 == qy {
			continue
		}
		for x in 0..<len(world[y]) {
			qx := x - len(world[y]) / 2
			if 0 == qx {
				continue
			}
			if qx < 0 {
				if qy < 0 {
					q0 += world[y][x]
				} else {
					q1 += world[y][x]
				}
			} else {
				if qy < 0 {
					q2 += world[y][x]
				} else {
					q3 += world[y][x]
				}
			}
		}
	}

	fmt.println(q0 * q1 * q2 * q3)
	*/

	i := 0
	for {
		for &bot in bots {
			world[bot.y][bot.x] -= 1
			nx := (bot.x + bot.vx) % len(world[0])
			ny := (bot.y + bot.vy) % len(world)
			bot.x = nx < 0 ? len(world[0]) + nx : nx
			bot.y = ny < 0 ? len(world) + ny : ny
			world[bot.y][bot.x] += 1
		}

		print := false
		outer: for w in world {
			count := 0
			for n in w {
				if 0 == n {
					count = 0
					continue
				}
				count += 1
				if count >= 10 {
					print = true
					break outer
				}
			}
		}

		i += 1

		if !print {
			continue
		}

		fmt.println(i)
		for w in world {
			count := 0
			for n in w {
				if 0 == n {
					fmt.print('.')
				} else {
					fmt.print(n)
				}
			}
			fmt.println()
		}

		buf: [8]byte
		nb, err := os.read(os.stdin, buf[:])
	}
}
