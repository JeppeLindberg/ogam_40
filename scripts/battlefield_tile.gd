extends StaticBody2D

var current_creature: Node2D


func _ready() -> void:
	add_to_group('tile')
	add_to_group('battlefield_tile')

func set_creature(new_creature):
	current_creature = new_creature

func unset_creature():
	current_creature = null





