extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var resolve_ui:Node2D = get_node('/root/main/battle/ui/resolve')

func deactivate():
	for tile in main.get_all_children(self, 'tile'):
		tile.deactivate()
	for ui in main.get_all_children(self, 'ui'):
		ui.deactivate()

	visible = false

func activate():
	for tile in main.get_all_children(self, 'tile'):
		tile.activate()
	resolve_ui.activate()

	visible = false

