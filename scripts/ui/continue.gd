extends StaticBody2D

@onready var collider: CollisionShape2D = get_node('collider')
@onready var world:Node2D = get_node('/root/main/world')


func _ready() -> void:
	add_to_group('ui')

func activate():
	collider.disabled = false
	visible = true

func deactivate():
	collider.disabled = true
	visible = false

func press_up():
	world.activate()
