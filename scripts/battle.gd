extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var resolve_ui:Node2D = get_node('/root/main/battle/ui/resolve')
@onready var player_lineup:Node2D = get_node('/root/main/battle/player_lineup')
@onready var enemy_lineup:Node2D = get_node('/root/main/battle/enemy_lineup')
@onready var center:Node2D = get_node('/root/main/battle/measures/center')
@onready var world:Node2D = get_node('/root/main/world')
@onready var creature_stats: Node2D = get_node('/root/main/battle/creature_stats')
@onready var effects: Node2D = get_node('/root/main/battle/effects')
@onready var creatures: Node2D = get_node('/root/main/battle/creatures')


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

	visible = false

func activate():
	world.deactivate()
	
	for tile in main.get_all_children(self, 'tile'):
		tile.activate()
	resolve_ui.activate()
	player_lineup.activate()
	enemy_lineup.activate()
	
	var cameras = main.get_all_children(main, 'camera')
	if not cameras.is_empty():
		cameras[0].reparent(center, false)

	visible = true
