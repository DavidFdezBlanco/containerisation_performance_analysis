#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1)
        return n;
    else
        return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    int n = 10;

    printf("Fibonnaci for 10 first terms:\n");
    for (int i = 0; i < n; i++) {
        int term = fibonacci(i);
        printf("%d ", term);
    }
    printf("\n");

    return 0;
}