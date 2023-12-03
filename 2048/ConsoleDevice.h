#include "IInputDevice.h"
#include <map>

class ConsoleDevice : public IInputDevice  {
public:
    ConsoleDevice();
    ~ConsoleDevice();
    virtual IInputDevice::Direction doInput();
private:
    std::map<char, IInputDevice::Direction> mp { 
        {'l', IInputDevice::Direction::LEFT},
        {'r', IInputDevice::Direction::RIGHT},
        {'u', IInputDevice::Direction::UP},
        {'d', IInputDevice::Direction::DOWN},
    };
};