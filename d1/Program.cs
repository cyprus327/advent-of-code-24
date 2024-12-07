using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;

Dictionary<int, int> map = new();
List<int> l1 = new(), l2 = new();
foreach (var line in File.ReadAllText("input.txt").Split('\n')) {
    string[] split = line.Split("   ");
    if (split.Length <= 1) {
        continue;
    }

    int n1 = int.Parse(split[0].Trim());
    l1.Add(n1);
    if (!map.TryGetValue(n1, out _)) {
        map[n1] = 0;
    }

    int n2 = int.Parse(split[1].Trim());
    l2.Add(n2);

    if (!map.TryGetValue(n2, out int val)) {
        map[n2] = val = 0;
    }
    map[n2] = val + 1;
}

l1.Sort();
l2.Sort();

ulong diffScore = 0;
for (int i = 0; i < l1.Count; i++) {
    diffScore += (ulong)Math.Abs(l1[i] - l2[i]);
}
Console.WriteLine($"Diff: {diffScore}");

ulong simScore = 0;
for (int i = 0; i < l1.Count; i++) {
    simScore += (ulong)(l1[i] * map[l1[i]]);
}
Console.WriteLine($"Sim:  {simScore}");
