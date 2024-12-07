package main

import "core:os"
import "core:fmt"
import "core:strconv"
import "core:strings"

main :: proc() {
	data: []u8; success: bool
	data, success = os.read_entire_file("input.txt")
	if !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	lines: []string = strings.split_lines(string(data))
	origChars: [dynamic][dynamic]rune = make([dynamic][dynamic]rune)

	opx, opy: int = 0, 0
	for line, lineNum in lines {
		if len(line) == 0 {
			continue
		}

		append(&origChars, make([dynamic]rune))
		for char, charInd in line {
			append(&origChars[lineNum], char)
			if '#' != char && '.' != char {
				opx = charInd
				opy = lineNum
			}
		}
	}

	distinctPositions: int = 0

	turns := map[rune]rune {
		'^' = '>',
		'v' = '<',
		'<' = '^',
		'>' = 'v'
	}

	/* Part 1
	for {
		cx, cy: int = px, py
		switch chars[py][px] {
			case '^': cy -= 1
			case 'v': cy += 1
			case '<': cx -= 1
			case '>': cx += 1
		}

		if cx < 0 || cx >= len(chars[0]) ||
		   cy < 0 || cy >= len(chars) {
			distinctPositions += 1
			break
		}

		switch chars[cy][cx] {
			case '#':
				chars[py][px] = turns[chars[py][px]]
				continue
			case '.':
				distinctPositions += 1
				fallthrough
			case '/':
				chars[cy][cx] = chars[py][px]
				chars[py][px] = '/'
		}

		px, py = cx, cy
	}
	*/

	for line, lineNum in origChars {
		for char, charInd in line {
			if '.' != char {
				continue
			}

			// chars: ^[dynamic][dynamic]rune = new_clone(origChars)
			chars: [dynamic][dynamic]rune = make([dynamic][dynamic]rune)
			for cloneLine, cloneLineNum in origChars {
				append(&chars, make([dynamic]rune))
				for cloneChar in cloneLine {
					append(&chars[cloneLineNum], cloneChar)
				}
			}
			chars[lineNum][charInd] = 'O'

			count, distinctCount := 0, 0
			infinite: bool = false

			px, py := opx, opy
			for {
				cx, cy: int = px, py
				switch chars[py][px] {
					case '^': cy -= 1
					case 'v': cy += 1
					case '<': cx -= 1
					case '>': cx += 1
				}

				if cx < 0 || cx >= len(origChars[0]) ||
				   cy < 0 || cy >= len(origChars) {
					distinctCount += 1
					break
				}

				c: rune = chars[cy][cx]

				if 'O' == c || '#' == c {
					chars[py][px] = turns[chars[py][px]]
					continue
				}

				if '.' == c {
					distinctCount += 1
				} else if '/' == c {
					count += 1
				}

				chars[cy][cx] = chars[py][px]
				chars[py][px] = '/'

				if count >= 2 * distinctCount {
					infinite = true
					break
				}

				px, py = cx, cy
			}

			if infinite {
				distinctPositions += 1
			}

			for _, cloneLineNum in origChars {
				delete(chars[cloneLineNum])
			}
			delete(chars)
		}

		fmt.println("Found:", distinctPositions)
	}

	fmt.println("Distinct:", distinctPositions)
}
