using System.Text;

StringBuilder sb = new();
foreach (var line in File.ReadAllLines("input.txt")) {
    sb.Append(line);
}
string input = sb.ToString();

bool mul = true;

ulong sum = 0;
string sub = input;
while (true) {
    int mulInd = -1;
    for (int d = 0; d < sub.Length; d++) {
        if (sub.Length >= d + 3 && "do" == sub[d..(d + 2)]) {
            mul = sub.Length >= d + 5 && "n't" != sub[(d + 2)..(d + 5)];
        } else if (sub.Length >= d + 3 && "mul" == sub[d..(d + 3)]) {
            mulInd = d;
            break;
        }
    }
    // mulInd = sub.IndexOf("mul");
    if (-1 == mulInd) {
        break;
    }

    sub = sub[(mulInd + 4)..];
    if (!mul || !char.IsNumber(sub[0])) {
        continue;
    }

    int commaInd = sub.IndexOf(',');
    int closingInd = sub.IndexOf(')');
    if (commaInd == -1 || closingInd == -1 || closingInd < commaInd) {
        continue;
    }

    if (int.TryParse(sub[..commaInd], out int n1) &&
        int.TryParse(sub[(commaInd + 1)..closingInd], out int n2)) {
        sum += (ulong)(n1 * n2);
    }
}

Console.WriteLine(sum);
