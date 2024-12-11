package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
	data: []u8; success: bool
	data, success = os.read_entire_file("input.txt")
	if !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines := strings.split_lines(string(data))
	split := strings.split_after(lines[0], " ")

	counts := make(map[string]int)
	defer delete(counts)

	for str in split {
		counts[strings.trim_space(str)] = 1
	}

	buf, strBuf := make([]u8, 12), make([]rune, 12)
	defer { delete(buf); delete(strBuf) }

	currCounts := make(map[string]int)
	defer delete(currCounts)

	for blink in 0..<75 {
		clear(&currCounts)
		for stone, count in counts {
			num := strconv.atoi(stone)
			if 0 == num {
				currCounts["1"] += count
			} else if 0 == len(stone) % 2 {
				mid := len(stone) / 2
				left := strings.trim_left(stone[:mid], "0")
				right := strings.trim_left(stone[mid:], "0")
				currCounts[left] += count
				currCounts[right] += count
			} else {
				// theres definitely a better way to do int to string
				for j in 0..<12 {
					buf[j] = '\x00'
				}
				strconv.itoa(buf, num * 2024)
				for char, j in buf {
					strBuf[j] = rune(char)
				}

				str := utf8.runes_to_string(strBuf)
				end := strings.index_rune(str, '\x00')
				str = strings.trim_left(str[:-1 == end ? len(str) : end], "0")
				currCounts["" == str ? "0" : str] += count
			}
		}

		clear(&counts)

		res: uint = 0
		for stone, count in currCounts {
			counts[stone] = count
			res += uint(count)
		}

		fmt.println(blink + 1, res)
	}
}
