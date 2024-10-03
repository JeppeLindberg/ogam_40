extends Node2D

@onready var battle: Node2D = get_node('/root/main/battle')

var initalized = false

func _process(_delta: float) -> void:
	if not initalized:
		battle.deactivate()


