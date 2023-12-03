#include <iostream>
#include "Board.h"
#include "IInputDevice.h"
#include "ConsoleDevice.h"

using namespace std;

void printMatrix(vector<vector<int>> m) {
    for(int i=0; i< m.size(); i++) {
        for(int j=0;j<m.size(); j++) {
            cout << m[i][j] << "  ,  ";
        }
        cout << endl;
    }
}

int main()
{
    shared_ptr<Board> board = make_shared<Board>(3);
    shared_ptr<IInputDevice> input(new ConsoleDevice());
    shared_ptr<Unit> unit = make_shared<Unit>();

    bool end = false;
    do
    {
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