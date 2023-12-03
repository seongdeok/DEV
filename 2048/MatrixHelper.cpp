#include "MatrixHelper.h"

bool MatrixHelper::rotateRight(std::vector<std::vector<int>> &matrix)
{
    //Transpos the matrix
    for (int i = 0; i < matrix.size(); ++i) {
        for (int j = i + 1; j < matrix[i].size(); ++j) {
            std::swap(matrix[i][j], matrix[j][i]);
        }
    }
    // Reverse each row
    for (int i = 0; i < matrix.size(); ++i) {
        std::reverse(matrix[i].begin(), matrix[i].end());
    }
    return true;    
}

bool MatrixHelper::compressToRight(std::vector<int> &array)
{
    std::vector<int> temp{};
    for(int i=0;i<array.size();i++){
        if( array[i] != -1)
            temp.push_back(array[i]);
    }
    int ptr = array.size() - 1;
    for(int i=temp.size() - 1; i >= 0;i--) {
        array[ptr--] = (i > 0 && temp[i - 1] == temp[i]) ? (temp[i--] << 1 ): temp[i];
    }    
    while( ptr >= 0){
        array[ptr--] = -1;
    }
    return true;    
}
