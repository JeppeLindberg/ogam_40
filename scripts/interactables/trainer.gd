extends Node2D

@onready var player: Node2D = get_node('/root/main/world/world_player')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/dialouge')
@onready var battle: Node2D = get_node('/root/main/battle')
@onready var lineup: Node2D = get_node('lineup')
@onready var enemy_lineup: Node2D = get_node('/root/main/battle/enemy_lineup')

@export var pre_battle_dialouge: Array[String]
@export var post_battle_dialouge: Array[String]

var pre_battle_dialouge_index = -1
var battle_commencing = false
var battle_complete = false
var post_battle_dialouge_index = -1


func _ready() -> void:
	add_to_group('interactable')

func interact():
	if pre_battle_dialouge_index == -1:
		player.active_interactable = self
		pre_battle_dialouge_index = 0;
		dialouge_ui.send_text(pre_battle_dialouge[pre_battle_dialouge_index])
	elif not battle_commencing:
		if dialouge_ui.progress():
			pre_battle_dialouge_index += 1;
			if pre_battle_dialouge_index >= len(pre_battle_dialouge):
				_start_battle()
				return;
			dialouge_ui.send_text(pre_battle_dialouge[pre_battle_dialouge_index])
	elif battle_complete and post_battle_dialouge_index == -1:
		post_battle_dialouge_index = 0
		dialouge_ui.send_text(post_battle_dialouge[post_battle_dialouge_index])
	elif battle_complete:
		if dialouge_ui.progress():
			post_battle_dialouge_index += 1;
			if post_battle_dialouge_index >= len(post_battle_dialouge):
				finish_interaction()
				return;
			dialouge_ui.send_text(post_battle_dialouge[post_battle_dialouge_index])

func _start_battle():
	dialouge_ui.clear_text()
	battle_commencing = true

	var i = 0
	for child in lineup.get_children():
		child.index = i
		child.trainer_owner = self
		child.reparent(enemy_lineup)
		i+=1

	battle.activate()

func return_from_battle():
	battle_complete = true
	interact()

func finish_interaction():
	pre_battle_dialouge_index = -1
	battle_commencing = false
	battle_complete = false
	post_battle_dialouge_index = -1

	dialouge_ui.clear_text()
	player.active_interactable = null
