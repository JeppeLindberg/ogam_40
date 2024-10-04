extends Node2D

@onready var main: Node = get_node('/root/main')

var _static := preload("res://scripts/library/static.gd").new()

@export var movement_speed: float = 10.0

var movement_direction: Vector2
var buffered_movement_direction: Vector2
var prev_position: Vector2

func _process(delta: float) -> void:
	_handle_controls(delta)

	if _static.to_indexes(prev_position) != _static.to_indexes(global_position):
		var prev_direction = (global_position - prev_position).normalized()
		if (prev_direction != movement_direction) or _is_pos_occupied(global_position + prev_direction * Vector2(_static.GRID_X, _static.GRID_Y)):		
			buffered_movement_direction = Vector2.ZERO
			global_position = _static.snap_to_grid(global_position)

	if (buffered_movement_direction == Vector2.ZERO) and (not _is_pos_occupied(global_position + movement_direction * Vector2(_static.GRID_X, _static.GRID_Y))):
		buffered_movement_direction = movement_direction

	prev_position = global_position

	global_position += buffered_movement_direction * movement_speed * delta


func _handle_controls(_delta):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input.x != 0:
		movement_direction = Vector2(input.x, 0).normalized();
	else:
		movement_direction = Vector2(0, input.y).normalized();

func _is_pos_occupied(pos):
	var nodes = main.get_nodes_at(pos, '', main.world_obstruction_layer)
	if nodes.is_empty():
		return false;
	else:
		return true;
	
