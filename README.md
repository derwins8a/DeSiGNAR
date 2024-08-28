> [!CAUTION]
> PLEASE check the original repository from the original author at https://github.com/R3mmurd/DeSiGNAR/ before proceeding

<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/3nity-studios/DeSiGNAR/main/logow.png">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/3nity-studios/DeSiGNAR/main/logob.png">
    <img alt="DeSiGNAR logo" src="https://raw.githubusercontent.com/3nity-studios/DeSiGNAR/main/logo.png">
  </picture>
</p>

# DeSiGNAR (Data Structures GeNeral librARy)

This is a library that implements important generic Data Structures and
algorithms.

The structure of this library is:

| Directory        | Description|
| :-------------:  |:-------------|
| *include*        | Contains all the header files |
| *src*            | Contains all the source files (implementations declared in headers) |
| *samples*       | Contains some demos with the usage of the different developed abstractions |
| *tests*          | Contains some tests of the different developed abstractions |

## Getting started

- Requirements
  - cmake >= 3.30 (it hasn't been tested with earlier versions)

- Compiling and installing the library

```shell
$ cmake -S . -B build
$ cmake --build build --config Release
$ cmake --install build --config Release
```

- Tests will be ran automatically after finishing if they were built.

After this, the static library `libDesignar-s.a` is located in the directory `/usr/local/lib/` probably

# Notes

> [!IMPORTANT]
> DISCLAIMER: This fork has been made solely for EDUCATIONAL PURPOSES and it contains BREAKING CHANGES as it's meant only for INTERNAL usage.

> [!WARNING]
> Support for building with CMake for platforms other than Linux has been dropped for the moment.

> [!NOTE]
> Shout-out to [SFML](https://github.com/SFML/SFML/), we kinda ripped off their CMake files. Also there are a lot of leftovers that weren't cleaned nor tested.
