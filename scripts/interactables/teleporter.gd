extends StaticBody2D

var _static := preload("res://scripts/library/static.gd").new()

@onready var player_world:Node2D = get_node('/root/main/world/world_player')
@onready var teleport_to:Node2D = get_node('teleport_to')


func _ready() -> void:
	add_to_group('trigger')

func trigger():
	player_world.teleport_to_pos(_static.snap_to_grid(teleport_to.global_position))
