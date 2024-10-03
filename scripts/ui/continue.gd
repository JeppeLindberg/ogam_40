extends StaticBody2D

@onready var creature_stats: Node2D = get_node('/root/main/battle/creature_stats')
@onready var effects: Node2D = get_node('/root/main/battle/effects')
@onready var collider: CollisionShape2D = get_node('collider')


func _ready() -> void:
	add_to_group('ui')

func activate():
	collider.disabled = false
	visible = true

func deactivate():
	collider.disabled = true
	visible = false


func press_up():
	creature_stats.clean_up()
	effects.clean_up()
