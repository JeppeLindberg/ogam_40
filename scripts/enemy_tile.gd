extends StaticBody2D

@onready var collider: CollisionShape2D = get_node('collider')

var current_creature: Node2D
var index: int


func _ready() -> void:
	add_to_group('tile')
	add_to_group('enemy_tile')

func set_creature(new_creature):
	if current_creature != null:
		current_creature.index = -1
	current_creature = new_creature
	new_creature.index = index

func unset_creature():
	if current_creature != null:
		current_creature.index = -1
	current_creature = null

func activate():
	collider.disabled = false
	
func deactivate():
	current_creature = null
	collider.disabled = true




