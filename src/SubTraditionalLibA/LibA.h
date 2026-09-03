#pragma once
#ifndef __LIB_A_H_
#define __LIB_A_H_

namespace LibA
{
    class HelloWorld
    {
    public:
        inline HelloWorld();
        {
           a = 10; 
        }

        void print() const;
    private:
        int a;
    };
}

#define __GRANT_LIB_A_INL_INCL_
#include "LibA_inl.h"
#undef __GRANT_LIB_A_INL_INCL_

#endif