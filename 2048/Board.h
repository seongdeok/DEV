#include "Unit.h"
#include <iostream>
#include "IInputDevice.h"


class Board {
public :
    Board(int _n);
    ~Board();
    bool Process(IInputDevice::Direction dir);
    bool DoLeft();
    bool DoRight();
    bool DoUp();
    bool DoDown();
    std::vector<std::vector<int>> getBoard();

private : 
    int row;
    std::vector<std::vector<int>> matrix;
    bool rotateLeft();
    bool rotateRight();
    bool compressToRight(std::vector<int>& matrix);
    bool generateUnitRandom();
};

