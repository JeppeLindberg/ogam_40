extends Node2D

@onready var main:Node = get_node('/root/main')

func _unhandled_input(event):
	if event is InputEventMouse:
		global_position = event.position

	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT) and (event.pressed):
			var tiles = main.get_nodes_at(event.position, 'tile')
			if not tiles.is_empty():
				var creature = tiles[0].current_creature
				if creature != null:
					creature.unset_target_position()
					creature.reparent(self)
					creature.position = Vector2.ZERO
				
		if (event.button_index == MOUSE_BUTTON_LEFT) and (not event.pressed):
			for child in get_children():
				child.drop()
