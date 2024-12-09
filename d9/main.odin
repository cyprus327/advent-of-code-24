package main

import "core:os"
import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

Block :: struct {
	id: int, length: u8, free: u8
}

main :: proc() {
	data: []u8; success: bool
	data, success = os.read_entire_file("input.txt")
	if !success {
		fmt.println("Failed to read input.txt")
		os.exit(1)
	}

	input: string = strings.split_lines(string(data))[0]

	blocks := make([dynamic]int)
	defer delete(blocks)

	id := 0
	for i := 0; i < len(input); i += 2 {
		count: u8 = input[i + 0] - '0'
		for _ in 0..<count {
			append(&blocks, id)
		}
		id += 1

		if i + 1 >= len(input) {
			continue
		}

		free:  u8 = input[i + 1] - '0'
		for _ in 0..<free {
			append(&blocks, -1)
		}
	}

	/* Part 1
	for i := 1; i < len(blocks); i += 1 {
		if -1 != blocks[i] {
			continue
		}

		for j := len(blocks) - 1; j > i; j -= 1 {
			if -1 == blocks[j] {
				continue
			}

			blocks[j], blocks[i] = blocks[i], blocks[j]
			break
		}
	}
	*/

	blocksLength := len(blocks)
	for i := blocksLength - 1; i >= 0; {
		curr, len := blocks[i], 0
		for i - len >= 0 && curr == blocks[i - len] {
			len += 1
		}

		if -1 == curr {
			i -= len
			continue
		}

		freeInd := -1
		for j := 1; j < i; j += 1 {
			if -1 != blocks[j] {
				continue
			}

			ind, size := j, 0
			for k := j; k < blocksLength && -1 == blocks[k]; k += 1 {
				size += 1
			}

			if size >= len {
				freeInd = ind
				break
			}
		}

		if freeInd == -1 {
			i -= len
			continue
		}

		for j := 0; j < len; j += 1 {
			blocks[freeInd + j], blocks[i - j] = blocks[i - j], blocks[freeInd + j]
		}
		i -= len
	}

	checksum := 0
	for e, i in blocks {
		if e < 0 {
			continue
		}

		checksum += i * e
	}

	fmt.println(checksum)
}
