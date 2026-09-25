module;

// TODO: Replace with import std
#include <type_traits>

export module ModuleA.Component1;

export
namespace ModuleA {

template <typename T>
concept Enum = std::is_enum_v<T>;

template <Enum E>
using PrimitiveType = std::underlying_type_t<E>;

template <Enum E>
constexpr auto rep(E e) { return PrimitiveType<E>(e); }

class Component1
{
public:
	void test();
};

} // export