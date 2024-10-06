extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var battle: Node2D = get_node('/root/main/battle')
@onready var world_player: Node2D = get_node('/root/main/world/world_player')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/container/dialouge')



func activate():
	battle.deactivate()

	world_player.return_from_battle()
	
	var cameras = main.get_all_children(main,'camera')
	if not cameras.is_empty():
		cameras[0].reparent(world_player, false)

	dialouge_ui.set_world_mode()

	visible = true

func deactivate():
	visible = false



