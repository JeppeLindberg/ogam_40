extends Node2D

@onready var main: Node = get_node('/root/main')
@onready var sprite:Node2D = get_node('player_sprite')

var _static := preload("res://scripts/library/static.gd").new()

@export var movement_speed: float = 10.0

var movement_direction: Vector2
var pending_interact: bool = false
var buffered_movement_direction: Vector2
var prev_position: Vector2
var look_direction = Vector2.DOWN
var active_interactable = null


func _process(delta: float) -> void:	
	_handle_controls(delta)

	if active_interactable != null:
		if pending_interact:
			pending_interact = false
			active_interactable.interact()
		return;

	if movement_direction != Vector2.ZERO:
		look_direction = movement_direction

	var prev_buffered_movement = buffered_movement_direction

	if _static.to_indexes(prev_position) != _static.to_indexes(global_position):
		var prev_direction = (global_position - prev_position).normalized()
		if (prev_direction != movement_direction) or _is_pos_occupied(global_position + prev_direction * Vector2(_static.GRID_SIZE, _static.GRID_SIZE)):		
			buffered_movement_direction = Vector2.ZERO
			global_position = _static.snap_to_grid(global_position)

	if (buffered_movement_direction == Vector2.ZERO) and (not _is_pos_occupied(global_position + movement_direction * Vector2(_static.GRID_SIZE, _static.GRID_SIZE))):
		buffered_movement_direction = movement_direction

	if (buffered_movement_direction == Vector2.ZERO) and pending_interact:
		pending_interact = false
		_handle_interact()
	else:
		prev_position = global_position
		global_position += buffered_movement_direction * movement_speed * delta

	_handle_sprite(prev_buffered_movement, buffered_movement_direction)

func _handle_controls(_delta):
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if input.x != 0:
		movement_direction = Vector2(input.x, 0).normalized();
	else:
		movement_direction = Vector2(0, input.y).normalized();

	if Input.is_action_just_pressed('interact'):
		pending_interact = true

func _is_pos_occupied(pos):
	var nodes = main.get_nodes_at(pos, '', main.world_obstruction_layer)
	if nodes.is_empty():
		return false;
	else:
		return true;
	
func _handle_sprite(prev_direction, new_direction):
	if prev_direction != new_direction:
		if prev_direction != Vector2.UP and new_direction == Vector2.UP:
			sprite.walk_up()
		elif prev_direction != Vector2.DOWN and new_direction == Vector2.DOWN:
			sprite.walk_down()
		elif prev_direction != Vector2.LEFT and new_direction == Vector2.LEFT:
			sprite.walk_left()
		elif prev_direction != Vector2.RIGHT and new_direction == Vector2.RIGHT:
			sprite.walk_right()
	elif new_direction == Vector2.ZERO:
		if look_direction == Vector2.UP:
			sprite.look_up()
		elif look_direction == Vector2.DOWN:
			sprite.look_down()
		elif look_direction == Vector2.LEFT:
			sprite.look_left()
		elif look_direction == Vector2.RIGHT:
			sprite.look_right()

func _handle_interact():
	var interactables = main.get_nodes_at(global_position + look_direction * (_static.GRID_SIZE * 0.75), 'interactable')
	if not interactables.is_empty():
		interactables[0].interact()
