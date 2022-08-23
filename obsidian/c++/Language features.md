- [const ref vs move semantics](https://stackoverflow.com/questions/17642357/const-reference-vs-move-semantics)
- [check container has pairs or not](https://stackoverflow.com/a/63282479/9105459)
```c++
#include <map>
#include <vector>
#include <type_traits>

template<class T>
void doWork(T t) {
    t *=2;
}

template <typename T>
struct is_pair : std::false_type { };

template <typename T, typename U>
struct is_pair<std::pair<T, U>> : std::true_type { };

template<class Iterator>
void fun(Iterator f, Iterator l)
{
    for(; f != l; ++f)
    {
        if constexpr(is_pair<std::decay_t<decltype(*f)>>::value) {
            doWork(f->second);
        } else {
            doWork(*f);
        }

    }
}
int main()
{
    std::vector<int> v;
    std::map<int,int> m;

    fun(v.begin(), v.end());
    fun(m.begin(), m.end());
}
```
- [std::forward](https://stackoverflow.com/questions/8526598/how-does-stdforward-work)
- [differentiate between two aliases using same type](https://stackoverflow.com/a/41300585/9105459) (hint: make them proper classes)
```c++
struct A : public std::vector<int>{
  using vector::vector;
};
struct B : public std::vector<int>{
  using vector::vector;
};
```
