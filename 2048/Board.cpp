#include "Board.h"
#include <random>
#include <functional>

Board::Board(int _n)
{
    row = _n;
    matrix.assign( row, std::vector<int>(row, -1));
}

Board::~Board()
{
}

bool Board::Process(IInputDevice::Direction dir)
{

    return false;
}

bool Board::DoDown()
{
    rotateLeft();
    DoRight();
    rotateRight();
    return false;
}

bool Board::DoUp()
{
    rotateRight();
    DoRight();
    rotateLeft();
    return false;
}

bool Board::DoLeft()
{
    rotateLeft();
    rotateLeft();
    DoRight();
    rotateLeft();
    rotateLeft();
    return false;
}

bool Board::compressToRight(std::vector<int>& array) {
    std::vector<int> temp;
    for(int i=0;i<array.size();i++){
        if( array[i] != -1)
            temp.push_back(array[i]);
    }
    int ptr = array.size() - 1;
    for(int i=temp.size() - 1; i >= 0;i--) {
        //array[ptr--] = i > 0 && temp[i - 1] == temp[i] ? temp[i] << 1 : temp[i];
        array[ptr--] = (i > 0 && temp[i - 1] == temp[i]) ? (temp[i--] << 1 ): temp[i];
    }    
    while( ptr >= 0){
        array[ptr--] = -1;
    }
    return false;
}

bool Board::DoRight()
{
    for(int i=0; i< matrix.size();i++) {
        compressToRight(matrix[i]);
    }
    return false;
}

bool Board::rotateRight() 
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

bool Board::rotateLeft()
{
    rotateRight();
    rotateRight();
    rotateRight();
    return true;
}

bool Board::generateUnitRandom() {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<int> dis(0, matrix.size() - 1);
    int r,c;
    do{
        r = dis(gen);
        c = dis(gen);
    } while( matrix[r][c] != -1);
    matrix[r][c] = 2;
    return true;
}

std::vector<std::vector<int>> Board::getBoard() {
    return matrix;
}