const OFFSET_X = 26
const OFFSET_Y = 26
const GRID_X = 52
const GRID_Y = 52

func snap_to_grid(vec):
    return(Vector2(((vec.x + OFFSET_X)/GRID_X) * GRID_X - OFFSET_X, round((vec.y + OFFSET_Y)/GRID_Y) * GRID_Y - OFFSET_Y))

func to_indexes(vec):
    return(Vector2i(floor((vec.x + OFFSET_X)/GRID_X), floor((vec.y + OFFSET_Y)/GRID_Y)))
