package main

import "core:os"
import "core:fmt"
import "core:math"
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

	solutionCount: uint = 0
	for line, lineNum in lines {
		if len(line) == 0 {
			continue
		}

		colonInd := strings.index_rune(line, ':')
		goal := strconv.atoi(line[0:colonInd])
		numStrs := strings.split(line[colonInd + 2:], " ")
		nums: [dynamic]int = make([dynamic]int)

		test := 1
		for numStr in numStrs {
			num := strconv.atoi(numStr)
			append(&nums, num)
			test *= num
		}

		/* Part 1
		count: uint = len(nums) - 1
		combos: uint = 1 << count
		for c: uint = 0; c < combos; c += 1 {
			res := nums[0]
			for i: uint = 0; i < count; i += 1 {
				if (c & (1 << i)) != 0 {
					res *= nums[i + 1]
				} else {
					res += nums[i + 1]
				}
			}

			if res == goal {
				solutionCount += uint(res)
				break // only count once
			}
		}
		*/

		count: uint = len(nums) - 1
		combos: uint = uint(math.pow_f32(3, f32(count)))
		for c: uint = 0; c < combos; c += 1 {
			res, t := nums[0], c
			for i: uint = 0; i < count; i += 1 {
				switch t % 3 {
					case 0: res += nums[i + 1]
					case 1: res *= nums[i + 1]
					case 2: res = combine_ints(res, nums[i + 1])
				}
				t /= 3
			}

			if res == goal {
				solutionCount += uint(res)
				break // only count once
			}
		}

		delete(nums)
	}

	fmt.println(solutionCount)
}

combine_ints :: proc(a: int, b: int) -> int {
	bd: f32 = b == 0 ? 1.0 : math.log10_f32(f32(b)) + 1.0
	return a * int(math.pow10_f32(bd)) + b
}
