extends Node2D

var _static := preload("res://scripts/library/static.gd").new()

@onready var player: Node2D = get_node('/root/main/world/world_player')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/container/dialouge')
@onready var sprite: Sprite2D = get_node('sprite')

@export var dialouge: Array[String]
@export var dialouge_texture_rect: Rect2

var dialouge_index = -1


func _ready() -> void:
	add_to_group('interactable')

func interact():
	if dialouge_index == -1:
		var self_to_player = _static.to_direction(global_position, player.global_position)
		if self_to_player == Vector2.UP:
			sprite.look_up()
		elif self_to_player == Vector2.DOWN:
			sprite.look_down()
		elif self_to_player == Vector2.LEFT:
			sprite.look_left()
		elif self_to_player == Vector2.RIGHT:
			sprite.look_right()

		player.active_interactable = self
		dialouge_index = 0;
		dialouge_ui.set_texture_rect(dialouge_texture_rect)
		dialouge_ui.send_text(dialouge[dialouge_index])
	else:
		if dialouge_ui.progress():
			dialouge_index += 1;
			if dialouge_index >= len(dialouge):
				finish_interaction()
				return;
			dialouge_ui.send_text(dialouge[dialouge_index])

func finish_interaction():
	dialouge_index = -1
	dialouge_ui.clear_text()
	player.active_interactable = null

func start_intro_cutscene():
	print('bla')
