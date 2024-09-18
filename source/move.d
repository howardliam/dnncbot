module move;

import std.string, std.stdio, std.regex;

import game;

class Move
{
    public int tile;
    public Side sideToMove;

    this(int tile, Side sideToMove)
    {
        this.tile = tile;
        this.sideToMove = sideToMove;
    }
}

bool validateStringMove(string move)
{
    move = move.strip();
    move = move.toLower();

    if (move.length > 2)
    {
        return false;
    }

    auto moveRegex = regex(r"[abc][123]");
    if (!matchFirst(move, moveRegex))
    {
        return false;
    }

    return true;
}

Move moveFromString(string move, Side sideToMove)
{
    move = move.toLower();

    int file = move[0] - 'a';
    int rank = move[1] - '1';

    return new Move((rank * 3) + file, sideToMove);
}
