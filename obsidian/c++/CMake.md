Compilation and linking is different processes. Compilation turns source code into machine readable *objects* and linker add these objects to each other and create an executable. 

To include a local library:
- Add a sub-directory with `add_subdirectory(directory)`
- `target_include_directories(directory)` 
	- This step is sufficient for header-only libraries because headers directly copied into source files and header-only libs include their implementation with them. But, with header-source couples, we need the implementations. The compiler does not search for implementation if it is not provided in the file but linker searches and finds. If it can't find the implementation than linker gives error. [An SO answer explains nicely](https://stackoverflow.com/a/20044489/9105459)
- `target_link_libraries(target [PUBLIC | PRIVATE | INTERFACE] library_target)` 
	- This step is required for libraries that is not header-only libraries.

cmake target_link_libraries PUBLIC, PRIVATE, INTERFACE difference
- https://cmake.org/pipermail/cmake/2016-May/063400.html
- https://leimao.github.io/blog/CMake-Public-Private-Interface/ 
