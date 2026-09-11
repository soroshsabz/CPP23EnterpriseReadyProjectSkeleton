#include "LibA.h"

#include <iostream>

namespace LibA
{

void HelloWorld::print() const
{
    std::cout << "a: " << a << std::endl;
}

}