#include <stdio.h>
#include <stdlib.h>

struct Dimensions {
    int height;
    int width;
};

struct Dimensions get_map_dimensions(const char *filename) {
    struct Dimensions dimensions;
    dimensions.height = 0;
    dimensions.width = 0;

    FILE *file_pointer;
    int bufferLength = 255;
    char buffer[bufferLength];

    file_pointer = fopen(filename, "r");
    if (file_pointer == NULL) {
        perror("Unable to open file");
        return dimensions;
    }

    int width = 0;
    int height = 0;

    while (fgets(buffer, bufferLength, file_pointer)) {
        for (int i = 0; i < bufferLength; i++) {
            char c = buffer[i];
            if (i > width) {
                width = i;
            }
            if (c == '\0' || c == '\n' || c == '\r') {
                break;
            }
        }
        height++;
    }
    fclose(file_pointer);
    free(file_pointer);
    dimensions.width = width;
    dimensions.height = height;
    return dimensions;
}

void read_file_into_map(const char *filename, int *map, struct Dimensions dimensions) {
    FILE *file_pointer;
    int bufferLength = 255;
    char buffer[bufferLength];

    file_pointer = fopen(filename, "r");
    if (file_pointer == NULL) {
        perror("Unable to open file");
        return;
    }

    int width = dimensions.width;

    int row = 0;
    while (fgets(buffer, bufferLength, file_pointer)) {
        for (int i = 0; i < bufferLength; i++) {
            char c = buffer[i];
            if (c == '\0' || c == '\n' || c == '\r') {
                break;
            }
            map[(row * width) + i] = c;
        }
        row++;
    }
    fclose(file_pointer);
    free(file_pointer);
}

int main() {
    const char *filename = "input.txt";
    struct Dimensions dimensions = get_map_dimensions(filename);
    int width = dimensions.width;
    int height = dimensions.height;

    int *map = calloc(width * height, sizeof(int));

    char tree = '#';

    read_file_into_map(filename, map, dimensions);

    int pos_row = 0;
    int pos_offset = 0;

    int tree_count = 0;
    while (pos_row < height - 1) {
        char pattern[] = {'r', 'r', 'r', 'd'};
        for (int i = 0; i < sizeof(pattern) / sizeof(pattern[0]); i++) {
            if (pattern[i] == 'r') {
                pos_offset++;
                if (pos_offset == width) {
                    pos_offset = 0;
                }
            } else if (pattern[i] == 'd') {
                pos_row++;
            }
        }
        char terrain = map[(pos_row * width) + pos_offset];
//        printf("%d %d %c\n", pos_row + 1, pos_offset + 1, terrain);
        if (terrain == tree) {
            tree_count++;
        }
    }
    free(map);

    printf("Part 1 Tree Count:  %d\n", tree_count);
    return 1;
}

