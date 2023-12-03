#include <iostream>
#include "Board.h"
#include "IInputDevice.h"
#include "ConsoleDevice.h"
#include "MatrixHelper.h"

using namespace std;

void printMatrix(vector<vector<int>> m) {
    for(int i=0; i< m.size(); i++) {
        for(int j=0;j<m.size(); j++) {
            cout << ((m[i][j] == -1) ? 0 : m[i][j] ) << "  ,  ";
        }
        cout << endl;
    }
}

int main()
{
    shared_ptr<Board> board = make_shared<Board>(3);
    shared_ptr<IInputDevice> input(new ConsoleDevice());
    shared_ptr<Unit> unit = make_shared<Unit>();

    MatrixHelper helper;
    vector<int> v { -1,-1,2,2,-1,2};
    helper.compressToRight(v);
    
    bool end = false;
    do
    {
        board->generateUnitRandom();
        printMatrix(board->getBoard());
        IInputDevice::Direction dir = input->doInput();
        switch (dir)
        {
        case IInputDevice::LEFT:
            end = board->DoLeft();
            break;
        case IInputDevice::RIGHT:
            end = board->DoRight();
            break;
        case IInputDevice::UP:
            end = board->DoUp();
            break;
        case IInputDevice::DOWN:
            end = board->DoDown();
            break;
        }
    } while( !end );

}