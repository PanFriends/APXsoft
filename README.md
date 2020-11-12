# APXsoft
TCL/TK, BASH, Python code for X-ray astronomy data analysis
## Installation
- TCL routines are designed to be used with [HEASARC](https://heasarc.gsfc.nasa.gov/docs/software.html)'s [XSPEC](https://heasarc.gsfc.nasa.gov/xanadu/xspec/). They should best be placed in the `.xspec` directory.
- [BASH](https://www.gnu.org/software/bash/) routines should be placed in a dedicated directory that is in your path. It is assumed that the path is `/bin/bash`.
- [GAWK](https://www.gnu.org/software/gawk/) should also be in your path. Please install, if not installed by default.

## Usage
- TCL routines are called from within XSPEC. See detailed documentation.
- BASH routines are either called from within some TCL routines or are used on the command line to call specific TCL or XSPEC tasks. See detailed documentation.

## Contributing
TBD

## Credits
This code grew from astrophysics X-ray analysis projects and ideas of Andy Ptak and Panayiotis Tzanavaris over the course of several years.

## License
[GNU General Public License 3.0](https://www.gnu.org/licenses/gpl-3.0.html)
