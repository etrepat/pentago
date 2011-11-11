# Pentago Bot/AI

This is an attempt at creating a game bot/ai for the board game [Pentago](http://en.wikipedia.org/wiki/Pentago).

It was developed as my personal project entry for the [Mendicant University](http://university.rubymendicant.com/)
January 2011 session.

### About the game / Mechanics

Pentago is two-player strategy board game which is played on a 6x6 board divided
into four 3x3 quadrants. Like this:

       0  1  2 | 3  4  5
      ---------+---------
    0| .  .  . | .  .  .
    1| .  .  . | .  .  .
    2| .  .  . | .  .  .
      ---------+---------
    3| .  .  . | .  .  .
    4| .  .  . | .  .  .
    5| .  .  . | .  .  .

The mechanics of the game are very simple: Taking turns, both players place a
marble onto an empty space on the board, and then rotate one of the quadrants
by 90 degress either clockwise or anti-clockwise. Any of the players win if they
get five of their marbles in a vertical, horizontal or diagonal row (before or
after the rotation step).

This is an example winning situation for Player 2 after 20 turns:

       0  1  2 | 3  4  5
      ---------+---------
    0| 2  2  2 | 2  2  .
    1| 2  .  2 | .  .  1
    2| 2  2  2 | .  1  .
      ---------+---------
    3| .  .  1 | .  .  .
    4| 1  .  . | 1  1  .
    5| 1  1  . | 1  1  .

More information about the game can be found on [its wikipedia page](http://en.wikipedia.org/wiki/Pentago).

### About Pentago Bot/AI

This project was conceived to be a playground for implementing/testing some
AI adversarial search algorithms.

For now, the pentago bot/ai presented here implements a simple console-based
interface which implements 3 player strategies:

* *Human player*: Movements are asked to the player through the console based
interface.
* *Dummy player*: Computes player moves randomly.
* *Negamax player*: Computes player moves based on an implementation of the
[Negamax](http://en.wikipedia.org/wiki/Negamax) algorithm (a slight variation of
the [Minimax](http://en.wikipedia.org/wiki/Minimax) algorithm).

Any combination of these player strategies can be used as a player for the game,
thus allowing the game to be played against a Human opponent, a computer opponent
or watch the computer play with itself.

### Usage

To try, test or use this program you can just:

1.  Clone the repo
2.  Install required gem dependencies via `bundle install`. This project depends on:
    [Highline](https://github.com/JEG2/highline) for console manipulation,
    [Rake](http://rake.rubyforge.org/) and [RSpec](https://www.relishapp.com/rspec) for testing.
3.  Launch the binary script, located in the `bin/` folder, specifying the desired
    player strategies to use for each of the players. For example, from the project's root:

    * Show help screen: `bin/pentago -h`
    * Human player (you) vs Negamax implementation: `bin/pentago --player1=Human --player2==Negamax`
    * Dummy player vs Negamax implementation: `bin/pentago --player1=Dummy --player2==Negamax`
    * Negamax vs Negamax: `bin/pentago --player1=Negamax --player2==Negamax`GIT

### TODO

* The [Negamax](http://en.wikipedia.org/wiki/Negamax) algorithm implementation
needs some re-thought/re-work as there are some assumptions in there which are
*not quite right*&trade;. Also, it's pretty *slow* if the search space depth is increased.
* Modularize better the game mechanics from the player strategies to get a better
player abstraction to implement more strategies easily.
* Implement more player strategies/algorithms. For example: [Negascout](http://en.wikipedia.org/wiki/Negascout),
[Monte Carlo Method](http://en.wikipedia.org/wiki/Monte_Carlo_method), [UCT](http://senseis.xmp.net/?UCT)
* Implement a backend module which allows for a web-application frontend to
communicate with the game engine.

### License

This Pentago Bot/AI project is released under the terms of the [MIT License](http://www.opensource.org/licenses/mit-license.php).

---

Coded by [Estanislau Trepat](http://etrepat.com).

