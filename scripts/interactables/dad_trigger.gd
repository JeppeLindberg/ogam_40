extends StaticBody2D

var _static := preload("res://scripts/library/static.gd").new()



func _ready() -> void:
	add_to_group('trigger')

func trigger():
	print('dad')
