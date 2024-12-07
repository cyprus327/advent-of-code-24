using System;
using System.IO;

string[] input = File.ReadAllLines("input.txt");
int w = input[0].Length, h = input.Length;

uint P1() {
    uint found = 0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            if (input[y][x] != 'X') {
                continue;
            }

            int xm1 = x - 1;
            int xm2 = x - 2;
            int xm3 = x - 3;
            int xp1 = x + 1;
            int xp2 = x + 2;
            int xp3 = x + 3;
            int ym1 = y - 1;
            int ym2 = y - 2;
            int ym3 = y - 3;
            int yp1 = y + 1;
            int yp2 = y + 2;
            int yp3 = y + 3;

            // north west
            if (xm1 >= 0 && ym1 >= 0 && input[ym1][xm1] == 'M' &&
                xm2 >= 0 && ym2 >= 0 && input[ym2][xm2] == 'A' &&
                xm3 >= 0 && ym3 >= 0 && input[ym3][xm3] == 'S') {
                found++;
            }

            // north
            if (ym1 >= 0 && input[ym1][x] == 'M' &&
                ym2 >= 0 && input[ym2][x] == 'A' &&
                ym3 >= 0 && input[ym3][x] == 'S') {
                found++;
            }

            // north east
            if (xp1 < w && ym1 >= 0 && input[ym1][xp1] == 'M' &&
                xp2 < w && ym2 >= 0 && input[ym2][xp2] == 'A' &&
                xp3 < w && ym3 >= 0 && input[ym3][xp3] == 'S') {
                found++;
            }

            // east
            if (xp1 < w && input[y][xp1] == 'M' &&
                xp2 < w && input[y][xp2] == 'A' &&
                xp3 < w && input[y][xp3] == 'S') {
                found++;
            }

            // south east
            if (xp1 < w && yp1 < h && input[yp1][xp1] == 'M' &&
                xp2 < w && yp2 < h && input[yp2][xp2] == 'A' &&
                xp3 < w && yp3 < h && input[yp3][xp3] == 'S') {
                found++;
            }
            
            // south
            if (yp1 < h && input[yp1][x] == 'M' &&
                yp2 < h && input[yp2][x] == 'A' &&
                yp3 < h && input[yp3][x] == 'S') {
                found++;
            }

            // south west
            if (xm1 >= 0 && yp1 < h && input[yp1][xm1] == 'M' &&
                xm2 >= 0 && yp2 < h && input[yp2][xm2] == 'A' &&
                xm3 >= 0 && yp3 < h && input[yp3][xm3] == 'S') {
                found++;
            }

            // west
            if (xm1 >= 0 && input[y][xm1] == 'M' &&
                xm2 >= 0 && input[y][xm2] == 'A' &&
                xm3 >= 0 && input[y][xm3] == 'S') {
                found++;
            }
        }
    }

    return found;
}

uint P2() {
    uint found = 0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            if (input[y][x] != 'A') {
                continue;
            }

            int xm1 = x - 1;
            int xp1 = x + 1;
            int ym1 = y - 1;
            int yp1 = y + 1;

            if (xm1 < 0 || ym1 < 0 || xp1 >= w || yp1 >= h) {
                continue;
            }

            if (((input[ym1][xm1] == 'M' && input[yp1][xp1] == 'S') ||
                 (input[ym1][xm1] == 'S' && input[yp1][xp1] == 'M')) &&
                ((input[yp1][xm1] == 'M' && input[ym1][xp1] == 'S') ||
                 (input[yp1][xm1] == 'S' && input[ym1][xp1] == 'M'))) {
                found++;
            }

            // doesn't count these for some reason
            // if (((input[y][xm1] == 'M' && input[y][xp1] == 'S') ||
            //      (input[y][xm1] == 'S' && input[y][xp1] == 'M')) &&
            //     ((input[ym1][x] == 'M' && input[yp1][x] == 'S') ||
            //      (input[ym1][x] == 'S' && input[yp1][x] == 'M'))) {
            //     found++;
            // }
        }
    }

    return found;
}

Console.WriteLine(args.Length > 0 && args[0] == "2" ? P2() : P1());

/*

  0 1 2 3 4 5 6
0 . . . . . . .
1 . . . . . . .
2 . . . . . . .
3 . . . . . . .
4 . . . . . . .

*/