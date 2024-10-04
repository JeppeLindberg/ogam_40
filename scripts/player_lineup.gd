extends Node2D

@onready var hand_tiles = get_node('/root/main/battle/tiles/hand_tiles')


func activate():
	var possible_positions = []
	for child in hand_tiles.get_children():
		possible_positions.append(child.global_position)
	

