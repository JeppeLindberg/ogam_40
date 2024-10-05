extends Node2D

@onready var battle: Node2D = get_node('/root/main/battle')



func activate():
	visible = true

func deactivate():
	visible = false



