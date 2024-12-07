package main

import "core:os"
import "core:fmt"
import "core:mem"
import "core:strconv"
import "core:strings"

main :: proc() {
	data: []u8; err: bool
	data, err = os.read_entire_file("input.txt")
	if !err {
		fmt.printfln("Error reading input")
		os.exit(1)
	}

	lines: []string = strings.split_lines(string(data))

	rules := make(map[i32][dynamic]i32)
	orderings := make([dynamic][dynamic]i32)
	orderingInd: i32 = 0

	sum: i32 = 0

	parsingRules: bool = true
	lineLoop: for line, lineNum in lines {
		if len(line) == 0 {
			parsingRules = false
			continue
		}

		if (parsingRules) {
			split: []string = strings.split(line, "|")
			num1, num2 := i32(strconv.atoi(split[0])), i32(strconv.atoi(split[1]))

			if (len(rules[num1]) == 0) {
				rules[num1] = make([dynamic]i32)
			}

			append(&rules[num1], num2)
			continue;
		}

		append(&orderings, make([dynamic]i32))

		split: []string = strings.split(line, ",")
		for numStr in split {
			num: i32 = i32(strconv.atoi(numStr))
			append(&orderings[orderingInd], num)
		}

		check: [dynamic]i32 = orderings[orderingInd]
		orderingInd += 1

		/* Part 1
		for i in 1..<len(check) {
			if !contains(rules[check[i - 1]], check[i]) {
				continue lineLoop
			}
		}
		sum += check[len(check) / 2]
		*/

		fixed: bool = false
		for i := 0; i < len(check); i += 1 {
			for j := i + 1; j < len(check); j += 1 {
				if contains(rules[check[i]], check[j]) {
					continue
				}

				check[i], check[j] = check[j], check[i]
				fixed = true
			}
		}

		if fixed {
			sum += check[len(check) / 2]
		}
	}

	fmt.printfln("Sum: %d", sum)
}

contains :: proc(nums: [dynamic]i32, val: i32) -> bool {
	for num in nums {
		if num == val {
			return true
		}
	}
	return false
}
