// ITNOA

import std;

import ModuleA;

#include "SubTraditionalLibA/LibA.h"

using namespace ModuleA;
using namespace LibA;

int main(int argc, char* argv[])
{
	std::cout << "salam" << std::endl;

	Component1 c1;
	c1.test();

	LibA::HelloWorld lhw;
	lhw.print();
}
