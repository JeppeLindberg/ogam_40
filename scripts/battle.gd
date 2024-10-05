extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var resolve_ui:Node2D = get_node('/root/main/battle/ui/resolve')
@onready var player_lineup:Node2D = get_node('/root/main/battle/player_lineup')
@onready var center:Node2D = get_node('/root/main/battle/measures/center')

func deactivate():
	for tile in main.get_all_children(self, 'tile'):
		tile.deactivate()
	for ui in main.get_all_children(self, 'ui'):
		ui.deactivate()
	player_lineup.deactivate()

	visible = false

func activate():
	for tile in main.get_all_children(self, 'tile'):
		tile.activate()
	resolve_ui.activate()
	player_lineup.activate()
	
	var cameras = main.get_all_children(main,'camera')
	if not cameras.is_empty():
		cameras[0].reparent(center, false)

	visible = true
