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

unsigned long long count_trees_for_pattern(int *map, struct Dimensions dimensions, char *pattern, int size) {
    char tree = '#';

    int pos_row = 0;
    int pos_offset = 0;

    int width = dimensions.width;
    int height = dimensions.height;

    int tree_count = 0;
    while (pos_row < height - 1) {
        for (int i = 0; i < size; i++) {
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
    return tree_count;
}

int main() {
    const char *filename = "input.txt";
    struct Dimensions dimensions = get_map_dimensions(filename);

    int *map = calloc(dimensions.width * dimensions.height, sizeof(int));

    read_file_into_map(filename, map, dimensions);

    char pattern_1_1[] = {'r', 'd'};
    char pattern_3_1[] = {'r', 'r', 'r', 'd'};
    char pattern_5_1[] = {'r', 'r', 'r', 'r', 'r', 'd'};
    char pattern_7_1[] = {'r', 'r', 'r', 'r', 'r', 'r', 'r', 'd'};
    char pattern_1_2[] = {'r', 'd', 'd'};

    int part_1_count = count_trees_for_pattern(map, dimensions, pattern_3_1, 4);
    unsigned long long part_2_count = count_trees_for_pattern(map, dimensions, pattern_1_1, 2)
                                      * count_trees_for_pattern(map, dimensions, pattern_3_1, 4)
                                      * count_trees_for_pattern(map, dimensions, pattern_5_1, 6)
                                      * count_trees_for_pattern(map, dimensions, pattern_7_1, 8)
                                      * count_trees_for_pattern(map, dimensions, pattern_1_2, 3);

    free(map);

    printf("Part 1 Tree Count:  %d\n", part_1_count);
    printf("Part 2 Tree Count:  %lld\n", part_2_count);
    return 1;
}

