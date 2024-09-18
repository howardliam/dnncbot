module bot;

import game, move;
import std.range, std.random, std.datetime, std.stdio;

class Bot
{
    private Side side;

    private float[9] startingTileWeights;
    private Move[] moves;

    private Random rng;

    this(Side side)
    {
        this.side = side;

        startingTileWeights = [
            1.0, 0.0, 1.0,
            0.0, 0.0, 0.0,
            1.0, 0.0, 1.0,
        ];

        // Seed random number generator
        auto currentTime = Clock.currTime();
        long unixTime = currentTime.toUnixTime();
        auto seeder = Random(cast(int) unixTime);
        rng = Random(uniform(0, int.max, seeder));
    }

    public void generateAllMoves(char[9] board)
    {
        Move[] generatedMoves;
        foreach (i, tile; board)
        {
            if (tile == EMPTY)
            {
                generatedMoves ~= new Move(cast(int) i, side);
            }
        }
        moves = generatedMoves;
    }

    public Move randomMove()
    {
        auto moveIndex = uniform(0, moves.length, rng);
        auto chosenMove = moves[moveIndex];

        return chosenMove;
    }
}
