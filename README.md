# RCLife

A Ruby + Curses implementation of [Conway's Game of Life](en.wikipedia.org/wiki/Conway's_Game_of_Life).

## Installation

To install, download the sources and run

    bundle install

## Usage

To run RCLife, run

    rclife

You can then control the simulation with your keyboard:

* Spacebar: Step the simulation.
* `P`: Toggle auto-run.
* Arrow keys and mouse: Move the cursor
* `X`: Toggle the currently highlighted cell between "live" and "dead".
* `C`: Clear the grid, resetting the simulation.
* `R`: Randomize the grid.
* `Q`: Quit the program.

## Acknowledgements

Curses code adapted from:

    https://github.com/grosser/tic_tac_toe/

## Contributing

This was very much a project for my own amusement, if you wanted to suggest a change for some reason:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
