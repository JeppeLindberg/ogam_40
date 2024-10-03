extends StaticBody2D

var current_creature: Node2D
var index: int


func _ready() -> void:
	add_to_group('tile')
	add_to_group('battlefield_tile')

func set_creature(new_creature):
	if current_creature != null:
		current_creature.state = ''
		current_creature.index = -1
	current_creature = new_creature
	new_creature.state = 'battlefield'
	new_creature.index = index

func unset_creature():
	if current_creature != null:
		current_creature.state = ''
		current_creature.index = -1
	current_creature = null





