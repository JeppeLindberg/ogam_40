extends Node2D


@onready var hand_tiles = get_node('/root/main/battle/tiles/hand_tiles')

var initialized = false

func _process(_delta: float) -> void:
	if not initialized:
		for child in get_children():
			if child.is_in_group('creature'):
				child.move_to_hand();
		initialized = true;

func add_creature(new_creature):
	var possible_positions = []

	for child in hand_tiles.get_children():
		possible_positions.append(child.global_position)

	for child in get_children():
		if child.is_in_group('creature'):
			possible_positions.erase(child.target_position)

	var closest_to_new_creature = possible_positions.duplicate();
	compare = new_creature.global_position
	closest_to_new_creature.sort_custom(_closest_to_c_ascending)

	new_creature.set_target_position(closest_to_new_creature[0])

var compare: Vector2

func _closest_to_c_ascending(a, b):
	return a.distance_to(compare) < b.distance_to(compare)
