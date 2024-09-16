module game;

import move, std.stdio;

const char NAUGHT = 'O';
const char CROSS = 'X';
const char EMPTY = '.';

enum Side
{
    NAUGHTS,
    CROSSES,
}

Side invertSide(Side side)
{
    return side == Side.CROSSES ? Side.NAUGHTS : Side.CROSSES;
}

char charFromSide(Side side)
{
    return side == Side.CROSSES ? CROSS : NAUGHT;
}

class Game
{
    private Side playerSide;

    private char[9] board;
    private bool gameOver = false;

    private Side sideToMove = Side.CROSSES;
    private Move[9] previousMoves;
    private int numberMoves = 0;

    this(Side playerSide)
    {
        this.playerSide = playerSide;

        this.board = [
            EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY, EMPTY
        ];
    }

    private void printGame()
    {
        string whoseMove = sideToMove == Side.CROSSES ? "Cross's move" : "Naught's move";
        string movesElapsed = numberMoves != 1 ? "moves elapsed" : "move elapsed";
        writefln("%s - %d %s", whoseMove, numberMoves, movesElapsed);

        int count = 0;
        int row = 1;
        foreach (tile; board)
        {
            if (count == 0)
            {
                writef("%d", row++);
            }

            writef(" %s ", tile);
            count += 1;

            if (count > 2)
            {
                write("\n");
                count = 0;
            }
        }
        writeln("  a  b  c");
    }

    private void makeMove(Move move)
    {
        char tile = board[move.tile];
        if (tile != CROSS && tile != NAUGHT)
        {
            char newTile = move.sideToMove == Side.CROSSES ? CROSS : NAUGHT;
            board[move.tile] = newTile;
        }

        previousMoves[numberMoves] = move;
        numberMoves++;

        sideToMove = invertSide(move.sideToMove);
        checkForWin(CROSS);
        checkForWin(NAUGHT);
    }

    private void unmakeMove(Move move)
    {
        Move previousMove = previousMoves[numberMoves - 1];
        bool sameTile = previousMove.tile == move.tile;
        bool sameSide = previousMove.sideToMove == move.sideToMove;

        if (!sameTile && !sameSide)
        {
            return;
        }

        sideToMove = move.sideToMove;
        previousMoves[numberMoves - 1] = null;
        numberMoves--;
        board[move.tile] = EMPTY;
    }

    private void checkForWin(char player)
    {
        foreach (i; 0 .. 3)
        {
            if (board[i * 3] == player && board[i * 3 + 1] == player && board[i * 3 + 2] == player)
            {
                gameOver = true;
            }
            if (board[i] == player && board[i + 3] == player && board[i + 6] == player)
            {
                gameOver = true;
            }
        }

        if (board[0] == player && board[4] == player && board[8] == player)
        {
            gameOver = true;
        }
        if (board[2] == player && board[4] == player && board[6] == player)
        {
            gameOver = true;
        }
    }

    void gameLoop()
    {
        while (!gameOver)
        {
            printGame();

            if (playerSide == sideToMove)
            {
                bool receivedValidInput = false;
                while (!receivedValidInput)
                {
                    write("Enter move ([a-c1-3]): ");
                    auto result = readln();
                    bool isValid = validateStringMove(result);
                    if (isValid)
                    {
                        auto move = moveFromString(result, playerSide);
                        makeMove(move);
                        receivedValidInput = true;
                    }
                }
            }
            else
            {
                // Do bot stuff here...
                writeln("Bot is thinking... ");
                sideToMove = sideToMove.invertSide();
            }
        }
        printGame();
    }
}
