#include <iostream>
#include <vector>

// Function to rotate a 2D array to the left
void rotateLeft(std::vector<std::vector<int>>& matrix) {
    // Transpose the matrix
    for (int i = 0; i < matrix.size(); ++i) {
        for (int j = i + 1; j < matrix[i].size(); ++j) {
            std::swap(matrix[i][j], matrix[j][i]);
        }
    }

    // Reverse each row
    for (int i = 0; i < matrix.size(); ++i) {
        std::reverse(matrix[i].begin(), matrix[i].end());
    }
}
void rotateRight(std::vector<std::vector<int>>& matrix) {
    // Transpose the matrix
    for (int i = 0; i < matrix.size(); ++i) {
        for (int j = i + 1; j < matrix[i].size(); ++j) {
            std::swap(matrix[i][j], matrix[j][i]);
        }
    }

    // Reverse each column
    for (int i = 0; i < matrix.size(); ++i) {
        std::reverse(matrix[i].begin(), matrix[i].end());
    }
}
// Function to print a 2D matrix
void printMatrix(const std::vector<std::vector<int>>& matrix) {
    for (const auto& row : matrix) {
        for (int value : row) {
            std::cout << value << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    // Example usage
    std::vector<std::vector<int>> matrix = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };

    std::cout << "Original Matrix:" << std::endl;
    printMatrix(matrix);

    //rotateLeft(matrix);
    rotateRight(matrix);
    std::cout << "\nMatrix after right rotation:" << std::endl;
    printMatrix(matrix);

    return 0;
}
