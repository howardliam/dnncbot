import std.stdio;

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
}

class Move
{
    public int tile;
    public bool isCrossMove;

    this(int tile, bool isCrossMove)
    {
        this.tile = tile;
        this.isCrossMove = isCrossMove;
    }
}

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

    // writeln("Edit source/app.d to start your project.");
}
