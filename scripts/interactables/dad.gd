extends Node2D

var _static := preload("res://scripts/library/static.gd").new()

@onready var player: Node2D = get_node('/root/main/world/world_player')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/container/dialouge')
@onready var sprite: Sprite2D = get_node('sprite')

@export var dialouge: Array[String]
@export var intro_cutscene_1_dialogue: Array[String]
@export var dialouge_texture_rect: Rect2

var _dialouge_index = -1
var _path_index = -1
var _path_nodes_dad: Array[Node2D]
var _path_nodes_player: Array[Node2D]
var _state = 'start'
var _target_position = Vector2.ZERO
var _prev_global_position = Vector2.ZERO
var _look_direction = Vector2.ZERO

func _ready() -> void:
	add_to_group('interactable')

func _process(delta: float) -> void:
	_prev_global_position = global_position
	
	if _state == 'intro_cutscene_1':
		var first_iteration = false
		if global_position == _target_position:
			global_position = _static.snap_to_grid(global_position)
			_path_index += 1
			if _path_index >= len(_path_nodes_dad):
				finish_interaction()
				return
			_target_position = _path_nodes_dad[_path_index].global_position
			first_iteration = true

		var movement_direction = (_target_position - global_position).normalized()

		global_position += movement_direction * player.movement_speed * delta
		if (not first_iteration) and (_static.to_indexes(_prev_global_position) != _static.to_indexes(global_position)):
			global_position = _target_position

	if _state == 'intro_cutscene_3':
		var first_iteration = false
		if player.global_position == _target_position:
			player.global_position = _static.snap_to_grid(player.global_position)
			_path_index += 1
			if _path_index >= len(_path_nodes_player):
				finish_interaction()
				return
			_target_position = _path_nodes_player[_path_index].global_position
			first_iteration = true

		var movement_direction = (_target_position - player.global_position).normalized()

		var player_prev_pos = player.global_position
		player.global_position += movement_direction * player.movement_speed * delta
		if (not first_iteration) and (_static.to_indexes(player_prev_pos) != _static.to_indexes(player.global_position)):
			player.global_position = _target_position

	_handle_sprite()


func interact():
	if _state in ['start', 'intro_cutscene_2']:
		if _dialouge_index == -1:
			_path_index = -1;
			_look_direction = _static.to_direction(global_position, player.global_position)

			player.active_interactable = self
			_dialouge_index = 0;
			dialouge_ui.set_texture_rect(dialouge_texture_rect)
			dialouge_ui.send_text(dialouge[_dialouge_index])
		else:
			if dialouge_ui.progress():
				_dialouge_index += 1;
				if _dialouge_index >= len(dialouge):
					finish_interaction()
					return;
				dialouge_ui.send_text(dialouge[_dialouge_index])

func _handle_sprite():
	if _prev_global_position == global_position:
		if _look_direction == Vector2.UP:
			sprite.look_up()
		elif _look_direction == Vector2.DOWN:
			sprite.look_down()
		elif _look_direction == Vector2.LEFT:
			sprite.look_left()
		elif _look_direction == Vector2.RIGHT:
			sprite.look_right()
	else:
		var move_direction = _static.to_direction(_prev_global_position, global_position)
		_look_direction = move_direction
		if move_direction == Vector2.UP:
			sprite.walk_up()
		elif move_direction == Vector2.DOWN:
			sprite.walk_down()
		elif move_direction == Vector2.LEFT:
			sprite.walk_left()
		elif move_direction == Vector2.RIGHT:
			sprite.walk_right()

func finish_interaction():
	_dialouge_index = -1
	_path_index = -1
	dialouge_ui.clear_text()
	if _state == 'start':
		player.active_interactable = null
	elif _state == 'intro_cutscene_1':
		_state = 'intro_cutscene_2'
		dialouge = intro_cutscene_1_dialogue
		interact()
	elif _state == 'intro_cutscene_2':
		_state = 'intro_cutscene_3'
		_path_nodes_player = intro_cutscene_3_path
		_target_position = player.global_position
	elif _state == 'intro_cutscene_3':
		_state = 'intro_cutscene_4'
		_path_nodes_dad = intro_cutscene_4_path


var intro_cutscene_1_path:Array[Node2D] = []
var intro_cutscene_2_path:Array[Node2D] = []
var intro_cutscene_3_path:Array[Node2D] = []
var intro_cutscene_4_path:Array[Node2D] = []

func start_intro_cutscene(path_nodes):
	intro_cutscene_1_path = [path_nodes[0]]
	intro_cutscene_3_path = [path_nodes[1]]
	_state = 'intro_cutscene_1'
	_target_position = global_position
	player.active_interactable = self
	_path_nodes_dad = intro_cutscene_1_path
