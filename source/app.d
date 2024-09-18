import std.stdio;

import game, move;

void main()
{
    writeln("Welcome to Naughts and Crosses");

    auto gameManager = new GameManager();
    gameManager.run();
}
