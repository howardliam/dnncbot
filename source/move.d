module move;

import std.string, std.stdio;

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
    char file = move[0];
    if (file != 'a' && file != 'b' && file != 'c')
    {
        return false;
    }
    char rank = move[1];
    if (rank != '1' && rank != '2' && rank != '3')
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

    // writefln("file %d, rank %d", file, rank);

    return new Move((rank * 3) + file, sideToMove);
}
