module move;

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
