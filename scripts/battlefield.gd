extends Node2D


@onready var battlefield_tiles = get_node('/root/main/battle/tiles/battlefield_tiles')

func add_creature(new_creature):
	var possible_positions = []

	for child in battlefield_tiles.get_children():
		possible_positions.append(child.global_position)

	var erase_positions = []
	var blank_position_found = false
	var creature_position_found = false
	for i in range(len(possible_positions)):
		if not blank_position_found:
			creature_position_found = false
			for child in get_children():
				if child.is_in_group('creature') and child.target_position == possible_positions[i]:
					creature_position_found = true
					break

			if not creature_position_found:
				blank_position_found = true
		else:
			erase_positions.append(possible_positions[i])
	
	for pos in erase_positions:
		possible_positions.erase(pos)

	var closest_to_new_creature = possible_positions.duplicate();
	compare = new_creature.global_position
	closest_to_new_creature.sort_custom(_closest_to_c_ascending)

	for i in range(len(get_children()) -1, -1, -1):
		var child = get_child(i)
		if child.is_in_group('creature'):
			if child.target_position >= closest_to_new_creature[0]:
				child.set_target_position(child.target_position + Vector2(64, 0))

	new_creature.set_target_position(closest_to_new_creature[0])

func remove_creature(old_creature):
	var possible_positions = []

	for child in battlefield_tiles.get_children():
		possible_positions.append(child.global_position)
	
	var children = []
	for child in get_children():
		if child != old_creature and child.is_in_group('creature'):
			children.append(child)
	children.sort_custom(_pos_x_ascending)

	for i in range(len(children)):
		if children[i].is_in_group('creature'):
			if children[i].target_position > old_creature.target_position:
				children[i].set_target_position(possible_positions[i])

var compare: Vector2

func _closest_to_c_ascending(a, b):
	return a.distance_to(compare) < b.distance_to(compare)
	
func _pos_x_ascending(a, b):
	return a.global_position.x < b.global_position.x
