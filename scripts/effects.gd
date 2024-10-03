extends Node2D


func clean_up():
	for child in get_children():
		child.queue_free()
