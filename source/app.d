import std.stdio;

import game, move;

void main()
{
    writeln("Welcome to Naughts and Crosses");

    auto playerSide = Side.CROSSES;
    auto game = new Game(playerSide);
    game.gameLoop();
}
