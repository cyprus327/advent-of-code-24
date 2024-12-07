using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

int safeCount = 0, lineCount = 0;
foreach (var line in File.ReadAllLines("input.txt")) {
    lineCount++;

    string[] split = line.Split(' ');
    int[] nums = new int[split.Length];
    for (int i = 0; i < nums.Length; i++) {
        nums[i] = int.Parse(split[i].Trim());
    }

    for (int i = 0; i < nums.Length; i++) {
        List<int> taken = new(nums.Length - 1);
        for (int j = 0; j < nums.Length; j++) {
            if (j != i) {
                taken.Add(nums[j]);
            }
        }
        
        bool inc = taken[0] < taken[1], safe = true;
        for (int j = 0; j < taken.Count - 1; j++) {
            int d = inc ? taken[j + 1] - taken[j] : taken[j] - taken[j + 1];
            if (d <= 0 || d > 3) {
                safe = false;
                break;
            }    
        }
        if (safe) {
            safeCount++;
            break;
        }
    }
}

Console.WriteLine($"Safe: {safeCount}");