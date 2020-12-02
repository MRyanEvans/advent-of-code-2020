#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *filePointer;
    int bufferLength = 255;
    char buffer[bufferLength];

    filePointer = fopen("input.txt", "r");

    int *numbers = calloc(1, sizeof(int));
    int max = 0;

    while (fgets(buffer, bufferLength, filePointer)) {
        long n = atoi(buffer);
        if (n > max) {
            numbers = realloc(numbers, 2020 * sizeof(int));
            for (int i = max + 1; i < n; i++) {
                numbers[i] = 0;
            }
            max = n;
        }
        numbers[n] = 1;
    }
    fclose(filePointer);

    int part_1_product;
    for (int i = 0; i < max; i++) {
        if (numbers[i] == 1) {
            int counterpart = 2020 - i;
            if (numbers[counterpart] == 1) {
                part_1_product = i * counterpart;
                break;
            }
        }
    }

    int part_2_product;
    for (int i = 0; i < max; i++) {
        for (int j = i + 1; j < max; j++) {
            if (numbers[i] == 1 && numbers[j] == 1) {
                int counterpart = 2020 - i - j;
                if (counterpart >= 0 && numbers[counterpart] == 1) {
                    part_2_product = i * j * counterpart;
                    break;
                }
            }
        }
        if (part_2_product > 0) {
            break;
        }
    }

    free(numbers);

    printf("Part 1:  %d\n", part_1_product);
    printf("Part 2:  %d\n", part_2_product);
}