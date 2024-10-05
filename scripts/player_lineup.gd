extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var battle:Node2D = get_node('/root/main/battle')
@onready var hand_tiles:Node2D = get_node('/root/main/battle/tiles/hand_tiles')

var _static := preload("res://scripts/library/static.gd").new()


func activate():
	var player_lineup = get_children()
	var possible_indexes = [0,1,2,3,4,5]

	for i in range(len(player_lineup)):
		possible_indexes.erase(player_lineup[i].player_lineup_index)

	for i in range(len(player_lineup)):
		if player_lineup[i].player_lineup_index == -1:
			player_lineup[i].player_lineup_index = possible_indexes.pop_front()
	
	var possible_positions = []
	for child in hand_tiles.get_children():
		possible_positions.append(child.global_position)
	
	possible_positions.sort_custom(_static.x_ascending)

	for i in range(len(player_lineup)):
		player_lineup[i].global_position = possible_positions[player_lineup[i].player_lineup_index]
		player_lineup[i].move_to_hand()

func deactivate():
	for creature in main.get_all_children(battle, 'creature'):
		if creature.player_lineup_index != -1:
			creature.move_to_player_lineup()
