const OFFSET = 26
const GRID_SIZE = 52

func snap_to_grid(vec):
    return(Vector2(((vec.x + OFFSET)/GRID_SIZE) * GRID_SIZE - OFFSET, round((vec.y + OFFSET)/GRID_SIZE) * GRID_SIZE - OFFSET))

func to_indexes(vec):
    return(Vector2i(floor((vec.x + OFFSET)/GRID_SIZE), floor((vec.y + OFFSET)/GRID_SIZE)))

func pos_x_ascending(a, b):
    return a.global_position.x < b.global_position.x

func x_ascending(a, b):
    return a.x < b.x
