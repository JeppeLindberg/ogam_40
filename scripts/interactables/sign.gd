extends Node2D

@onready var player: Node2D = get_node('/root/main/world/world_player')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/container/dialouge')

@export var dialouge: Array[String]
@export var dialouge_texture_rect: Rect2

var dialouge_index = -1


func _ready() -> void:
	add_to_group('interactable')

func interact():
	if dialouge_index == -1:
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
