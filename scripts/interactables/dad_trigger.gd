extends StaticBody2D

@export var dad: Node2D
@export var path_nodes: Array[Node2D]


func _ready() -> void:
	add_to_group('trigger')

func trigger():
	dad.start_intro_cutscene(path_nodes)
