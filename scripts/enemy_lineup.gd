extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var battle:Node2D = get_node('/root/main/battle')
@onready var creatures:Node2D = get_node('/root/main/battle/creatures')
@onready var enemy_tiles:Node2D = get_node('/root/main/battle/tiles/enemy_tiles')

var _static := preload("res://scripts/library/static.gd").new()


func activate():
	var enemy_lineup = get_children()
	var possible_indexes = [0,1,2,3,4,5]

	for i in range(len(enemy_lineup)):
		possible_indexes.erase(enemy_lineup[i].index)

	for i in range(len(enemy_lineup)):
		if enemy_lineup[i].index == -1:
			enemy_lineup[i].index = possible_indexes.pop_front()
	
	var possible_positions = []
	for child in enemy_tiles.get_children():
		possible_positions.append(child.global_position)
	
	possible_positions.sort_custom(_static.x_ascending)

	for i in range(len(enemy_lineup)):
		enemy_lineup[i].global_position = possible_positions[enemy_lineup[i].index]
		enemy_lineup[i].move_to_enemy()

func deactivate():
	for creature in main.get_all_children(creatures, 'creature'):
		if creature.trainer_owner != null:
			creature.reparent(creature.trainer_owner.get_node('lineup'))

	for creature in get_children():
		creature.queue_free()
