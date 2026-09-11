#pragma once
#ifndef __LIB_A_H_
#define __LIB_A_H_

namespace LibA
{

class HelloWorld
{
public:
    inline HelloWorld();

    void print() const;
private:
    int a;
};

}   // end of namespace LibA

#define __GRANT_LIB_A_INL_INCL_
#include "LibA_inl.h"
#undef __GRANT_LIB_A_INL_INCL_

#endif