extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var player_lineup:Node2D = get_node('/root/main/battle/player_lineup')
@onready var enemy_lineup:Node2D = get_node('/root/main/battle/enemy_lineup')
@onready var center:Node2D = get_node('/root/main/battle/measures/center')
@onready var world:Node2D = get_node('/root/main/world')
@onready var creature_stats: Node2D = get_node('/root/main/battle/creature_stats')
@onready var effects: Node2D = get_node('/root/main/battle/effects')
@onready var creatures: Node2D = get_node('/root/main/battle/creatures')
@onready var dialouge_ui: Control = get_node('/root/main/ui/dialouge_container/container/dialouge')
@onready var battle_ui: Control = get_node('/root/main/ui/battle_container')

@export var resolve_button: Button
@export var battle_dialog_rect: Rect2

func activate():
	world.deactivate()
	
	for tile in main.get_all_children(self, 'tile'):
		tile.activate()
	player_lineup.activate()
	enemy_lineup.activate()
	var cameras = main.get_all_children(main, 'camera')
	if not cameras.is_empty():
		cameras[0].reparent(center, false)
	dialouge_ui.set_battle_mode()
	dialouge_ui.set_texture_rect(battle_dialog_rect)
	resolve_button.mouse_filter = Control.MOUSE_FILTER_STOP
	battle_ui.visible = true

	visible = true

func deactivate():
	creature_stats.clean_up()
	effects.clean_up()
	player_lineup.deactivate()
	enemy_lineup.deactivate()
	for creature in main.get_all_children(creatures, 'creature'):
		creature.queue_free()
	for tile in main.get_all_children(self, 'tile'):
		tile.deactivate()
	for ui in main.get_all_children(self, 'ui'):
		ui.deactivate()
	resolve_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	battle_ui.visible = false

	visible = false

