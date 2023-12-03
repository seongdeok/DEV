#ifndef IINPUTDEVICE_H
#define IINPUTDEVICE_H

class IInputDevice {
public : 
    enum Direction {
        LEFT = 0,
        RIGHT,
        UP,
        DOWN
    };
    virtual Direction doInput() = 0;
    
};
#endif