module game;

import move, std.stdio;

const char NAUGHT = 'O';
const char CROSS = 'X';
const char EMPTY = '.';

class Game
{
    private char[9] board;
    private bool isCrossMove = true;
    private int numberMoves = 0;

    private Move[9] previousMoves;

    this()
    {
        this.board = [
            EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY
        ];
    }

    void printGame()
    {
        string whoseMove = isCrossMove ? "Cross's move" : "Naught's move";
        string movesElapsed = numberMoves != 1 ? "moves elapsed" : "move elapsed";
        writefln("%s - %d %s", whoseMove, numberMoves, movesElapsed);

        int count = 0;
        foreach (tile; board)
        {
            writef(" %s ", tile);
            count += 1;

            if (count > 2)
            {
                write("\n");
                count = 0;
            }
        }
        writeln();
    }

    void makeMove(Move move)
    {
        char tile = board[move.tile];
        if (tile != CROSS && tile != NAUGHT)
        {
            char newTile = move.isCrossMove ? CROSS : NAUGHT;
            board[move.tile] = newTile;
        }

        previousMoves[numberMoves] = move;
        numberMoves++;

        isCrossMove = !move.isCrossMove;
    }

    void unmakeMove(Move move)
    {
        Move previousMove = previousMoves[numberMoves - 1];
        bool sameTile = previousMove.tile == move.tile;
        bool sameSide = previousMove.isCrossMove == move.isCrossMove;

        if (!sameTile && !sameSide)
        {
            return;
        }

        isCrossMove = move.isCrossMove;
        previousMoves[numberMoves - 1] = null;
        numberMoves--;
        board[move.tile] = EMPTY;
    }
}
