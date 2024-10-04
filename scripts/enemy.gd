extends Node2D


@onready var enemy_tiles = get_node('/root/main/battle/tiles/enemy_tiles')


var initalized = false

func _process(_delta: float) -> void:
	if not initalized:
		var possible_positions = []

		for tile in enemy_tiles.get_children():
			possible_positions.append(tile.global_position)

		possible_positions.sort_custom(_x_ascending)

		for i in range(len(possible_positions)):
			for tile in enemy_tiles.get_children():
				if tile.global_position == possible_positions[i]:
					tile.index = i
					break

		for child in get_children():
			if child.is_in_group('creature'):
				child.move_to_enemy();

		initalized = true

func add_creature(new_creature):
	var possible_positions = []

	for child in enemy_tiles.get_children():
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

var compare: Vector2

func _closest_to_c_ascending(a, b):
	return a.distance_to(compare) < b.distance_to(compare)
	
func _x_ascending(a, b):
	return a.x < b.x
