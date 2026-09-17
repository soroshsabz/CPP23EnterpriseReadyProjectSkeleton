#ifndef __LIB_A_H_
#error "This file must be included within the main header file of the same name."
#endif

#ifndef __GRANT_LIB_A_INL_INCL_
#error "This file must be used internally"
#endif

#ifndef __LIB_A_INL_H_
#define __LIB_A_INL_H_

namespace LibA
{

inline HelloWorld::HelloWorld()
: a(10)
{

}

}   // end of namespace LibA

#endif