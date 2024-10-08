module game;

import move, bot;
import std.stdio, std.random, std.datetime, std.string, std.algorithm;
import core.thread;

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
    private bool stalemate = false;
    private Side sideWon;

    private Side sideToMove = Side.CROSSES;
    private Move[9] previousMoves;
    private int numberMoves = 0;

    this(Side playerSide)
    {
        this.playerSide = playerSide;

        this.board = [
            EMPTY, EMPTY, EMPTY,
            EMPTY, EMPTY, EMPTY,
            EMPTY, EMPTY, EMPTY,
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
        checkForStalemate();
    }

    private void undoPreviousMove()
    {
        Move previousMove = previousMoves[numberMoves - 1];

        sideToMove = previousMove.sideToMove;
        previousMoves[numberMoves - 1] = null;
        numberMoves--;
        board[previousMove.tile] = EMPTY;
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

    private void checkForStalemate()
    {
        foreach (tile; board)
        {
            if (tile == EMPTY)
            {
                return;
            }
            else
            {
                continue;
            }
        }
        stalemate = true;
        gameOver = true;
    }
}

class GameManager
{
    private Game game;
    private Bot bot;

    private Random rng;

    this()
    {
        Side playerSide;

        bool sideSelected = false;
        while (!sideSelected)
        {
            write("Choose a side: naughts or crosses? (n/c) ");
            auto result = readln();
            result = result.strip();
            if (result == "n")
            {
                playerSide = Side.NAUGHTS;
                sideSelected = true;
            }
            else if (result == "c")
            {
                playerSide = Side.CROSSES;
                sideSelected = true;
            }
        }
        writeln();
        string side = playerSide == Side.CROSSES ? "crosses" : "naughts";
        writefln("You have selected %s!", side);
        writeln();

        game = new Game(playerSide);
        bot = new Bot(playerSide.invertSide);

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
        else if (game.stalemate)
        {
            writefln("After %d moves, the game finished on a stalemate!", game.numberMoves);
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
                    write("Enter tile to play ([abc][123]): ");
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
                }
                writeln();
            }
            else
            {
                writeln("Bot is thinking...\n");
                Thread.sleep(dur!("seconds")(1));

                bot.generateAllMoves(game.board);
                auto move = bot.randomMove();

                game.makeMove(move);
            }
        }
        printGame();
    }
}
