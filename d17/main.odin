package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

reg: [3]uint

main :: proc() {
	data: []u8; success: bool
	if data, success = os.read_entire_file("input.txt"); !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	input := strings.split_lines(string(data))

	for i in 0..<3 {
		reg[i] = uint(strconv.atoi(input[i][strings.index_rune(input[i], ':') + 2:]))
	}

	input = input[len(input) - 2:len(input) - 1]
	input[0] = input[0][strings.index_rune(input[0], ':') + 2:]

	instructions := make([]u8, len(input[0]) / 2 + 1)
	defer delete(instructions)

	for i := 0; i < len(instructions); i += 1 {
		instructions[i] = input[0][i * 2] - '0'
	}

	output := make([dynamic]u8)
	defer delete(output)

	/* Part 1
	ip := 0
	for ip < len(instructions) {
		ip = emulate(instructions, ip, &output)
	}
	*/

	aReg: uint = 0
	outer: for {
		reg[0] = aReg

		clear(&output)
		ip := 0
		for ip < len(instructions) {
			ip = emulate(instructions, ip, &output)
		}

		lo, li := len(output), len(instructions)
		if lo >= li {
			matches := true
			for i in 0..<li {
				if output[i] != instructions[i] {
					matches = false
				}
			}
			if matches {
				break outer
			}
		}

		matches := true
		for i in 0..<min(lo, li) {
			if output[lo - i - 1] != instructions[li - i - 1] {
				matches = false
				break
			}
		}

		if matches {
			aReg *= 8
		}

		aReg += 1
	}

	fmt.println(aReg - 1, output, instructions)
}

emulate :: proc(instructions: []u8, ip: int, output: ^[dynamic]u8) -> int {
	nextIP := ip
	switch instructions[ip] {
		case 0: { // 'adv', division, reg[A] /= 2^(combo)
			combo := combo_op(instructions[ip + 1])
			reg[0] /= uint(1 << uint(combo % 32))
		}
		case 1: { // 'bxl', bitwise xor, reg[B] ^= literal
			reg[1] ~= uint(instructions[ip + 1]) // xor in odin is ~ not ^
		}
		case 2: { // 'bst', reg[B] = combo % 8
			reg[1] = combo_op(instructions[ip + 1]) % 8
		}
		case 3: { // 'jnz', jump if reg[A] not 0, op is literal
			if 0 == reg[0] {
				break
			}
			nextIP = int(instructions[ip + 1]) - 2
		}
		case 4: { // 'bxc', bitwise xor, reg[B] ^= reg[C], does nothing with op
			reg[1] ~= reg[2]
		}
		case 5: { // 'out', output combo % 8
			append(output, u8(combo_op(instructions[ip + 1]) % 8))
		}
		case 6: { // 'bdv', same as 'adv' but stored in B
			combo := combo_op(instructions[ip + 1])
			reg[1] = reg[0] / uint(1 << uint(combo % 32))
		}
		case 7: { // 'cdv', same as 'adv' but stored in C
			combo := combo_op(instructions[ip + 1])
			reg[2] = reg[0] / uint(1 << uint(combo % 32))
		}
	}

	return nextIP + 2
}

combo_op :: proc(n: u8) -> uint {
	switch n {
		case 0..=3: return uint(n)
		case 4: return reg[0]
		case 5: return reg[1]
		case 6: return reg[2]
		case:
			fmt.println("ERROR, INVALID COMBO OP:", n)
			os.exit(1)
	}
}
