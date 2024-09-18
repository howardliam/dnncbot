module game;

import move, std.stdio, std.random, std.datetime;

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
    private Side sideWon;

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

    private void undoPreviousMove(Move move)
    {
        // Move previousMove = previousMoves[numberMoves - 1];
        // bool sameTile = previousMove.tile == move.tile;
        // bool sameSide = previousMove.sideToMove == move.sideToMove;

        // if (!sameTile && !sameSide)
        // {
        //     return;
        // }

        // sideToMove = move.sideToMove;
        // previousMoves[numberMoves - 1] = null;
        // numberMoves--;
        // board[move.tile] = EMPTY;
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

        if (gameOver)
        {
            if (player == NAUGHT)
            {
                sideWon = Side.NAUGHTS;
            }
        }
    }
}

class GameManager
{
    private Game game;

    private Random rng;

    this()
    {
        game = new Game(Side.CROSSES);

        // Seed random number generator
        auto currentTime = Clock.currTime();
        long unixTime = currentTime.toUnixTime();
        auto seeder = Random(cast(int) unixTime);
        rng = Random(uniform(0, int.max, seeder));
    }

    private void printGame()
    {
        if (!game.gameOver)
        {
            string whoseMove = game.sideToMove == Side.CROSSES ? "Cross's move" : "Naught's move";
            string movesElapsed = game.numberMoves != 1 ? "moves elapsed" : "move elapsed";
            writefln("%s - %d %s", whoseMove, game.numberMoves, movesElapsed);
        }
        else if (game.gameOver)
        {
            string whoWon = game.sideWon == Side.NAUGHTS ? "Naughts" : "Crosses";
            writefln("%s has won after %d moves!", whoWon, game.numberMoves);
        }

        int count = 0;
        int row = 1;
        foreach (tile; game.board)
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
        writeln("  a  b  c\n");
    }

    public void run()
    {
        while (!game.gameOver)
        {
            printGame();

            if (game.playerSide == game.sideToMove)
            {
                bool receivedValidInput = false;
                while (!receivedValidInput)
                {
                    write("Enter move ([abc][123]): ");
                    auto result = readln();
                    bool isValid = validateStringMove(result);
                    if (isValid)
                    {
                        auto move = moveFromString(result, game.playerSide);
                        bool tileOccupied = game.board[move.tile] != EMPTY;
                        if (!tileOccupied)
                        {
                            game.makeMove(move);
                            receivedValidInput = true;
                        }
                    }
                    writeln();
                }
            }
            else
            {
                writeln("Bot is thinking...\n");

                // Generate every possible move
                auto botSide = game.playerSide.invertSide();
                Move[] generatedMoves;
                foreach (i, tile; game.board)
                {
                    if (tile == EMPTY)
                    {
                        generatedMoves ~= new Move(cast(int) i, botSide);
                    }
                }

                // Random move selection
                auto moveIndex = uniform(0, generatedMoves.length, rng);
                auto chosenMove = generatedMoves[moveIndex];

                game.makeMove(chosenMove);
            }
        }
        printGame();
    }
}
