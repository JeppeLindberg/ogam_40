extends Node2D

@onready var main: Node = get_node('/root/main')
@onready var sprite:Node2D = get_node('player_sprite')

var _static := preload("res://scripts/library/static.gd").new()

@export var movement_speed: float = 10.0

var _movement_direction: Vector2
var _pending_interact: bool = false
var _buffered_movement_direction: Vector2
var _prev_global_positions: Array[Vector2]
var _look_direction = Vector2.DOWN
var active_interactable = null


func _process(delta: float) -> void:
	_handle_controls(delta)

	while len(_prev_global_positions) < 2:
		_prev_global_positions.push_front(global_position)

	if _static.to_indexes(_prev_global_positions[0]) != _static.to_indexes(global_position):
		var triggers = main.get_nodes_at(_static.snap_to_grid(global_position), 'trigger')
		var prev_direction = (global_position - _prev_global_positions[0]).normalized()

		if not triggers.is_empty():
			global_position = _static.snap_to_grid(global_position)
			triggers[0].trigger()
			_buffered_movement_direction = Vector2.ZERO
		elif (prev_direction != _movement_direction) or _is_pos_occupied(global_position + prev_direction * Vector2(_static.GRID_SIZE, _static.GRID_SIZE)):
			global_position = _static.snap_to_grid(global_position)
			_buffered_movement_direction = Vector2.ZERO

	_prev_global_positions.push_front(global_position)
	_prev_global_positions.pop_back()

	if active_interactable == null:
		if (_buffered_movement_direction == Vector2.ZERO) and (not _is_pos_occupied(global_position + _movement_direction * Vector2(_static.GRID_SIZE, _static.GRID_SIZE))):
			_buffered_movement_direction = _movement_direction

		if (_buffered_movement_direction == Vector2.ZERO) and _pending_interact:
			_pending_interact = false
			_handle_interact()
		else:
			global_position += _buffered_movement_direction * movement_speed * delta
	else:
		if _pending_interact:
			_pending_interact = false
			active_interactable.interact()

	_handle_sprite()

func return_from_battle():
	if active_interactable != null:
		active_interactable.return_from_battle()

func _handle_controls(_delta):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input.x != 0:
		_movement_direction = Vector2(input.x, 0).normalized();
	else:
		_movement_direction = Vector2(0, input.y).normalized();

	if Input.is_action_just_pressed('interact'):
		_pending_interact = true

func _is_pos_occupied(pos):
	var nodes = main.get_nodes_at(pos, '', main.world_obstruction_layer)
	if nodes.is_empty():
		return false;
	else:
		return true;
	
func _handle_sprite():
	if _prev_global_positions[1] == global_position:
		if _look_direction == Vector2.UP:
			sprite.look_up()
		elif _look_direction == Vector2.DOWN:
			sprite.look_down()
		elif _look_direction == Vector2.LEFT:
			sprite.look_left()
		elif _look_direction == Vector2.RIGHT:
			sprite.look_right()
	else:
		var move_direction = _static.to_direction(_prev_global_positions[1], global_position)
		_look_direction = move_direction
		if move_direction == Vector2.UP:
			sprite.walk_up()
		elif move_direction == Vector2.DOWN:
			sprite.walk_down()
		elif move_direction == Vector2.LEFT:
			sprite.walk_left()
		elif move_direction == Vector2.RIGHT:
			sprite.walk_right()

func _handle_interact():
	var interactables = main.get_nodes_at(global_position + _look_direction * (_static.GRID_SIZE * 0.75), 'interactable')
	if not interactables.is_empty():
		interactables[0].interact()
