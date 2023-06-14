#include <stdio.h>

// Fonction pour calculer le terme de Fibonacci
int fibonacci(int n) {
    if (n <= 1)
        return n;
    else
        return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    int n = 10; // Nombre de termes de Fibonacci à calculer

    printf("Suite de Fibonacci pour les %d premiers termes:\n", n);
    for (int i = 0; i < n; i++) {
        int term = fibonacci(i);
        printf("%d ", term);
    }
    printf("\n");

    return 0;
}
