#include "ConsoleDevice.h"
#include <iostream>

ConsoleDevice::ConsoleDevice()
{
}

ConsoleDevice::~ConsoleDevice()
{
}

IInputDevice::Direction ConsoleDevice::doInput()
{
    char c;
    std::cin >> c;
    return mp[c];
}
