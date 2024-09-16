import std.stdio;

import game, move;

void main()
{
    auto game = new Game;
    game.printGame();

    auto move = new Move(1, true);
    game.makeMove(move);
    game.printGame();

    auto move2 = new Move(4, false);
    game.makeMove(move2);
    game.printGame();

    game.unmakeMove(move2);
    game.printGame();
}
