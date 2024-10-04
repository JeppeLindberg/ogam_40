extends Node

@onready var battle:Node2D = get_node('/root/main/battle')

@export_flags_2d_physics var world_obstruction_layer

var _curr_secs:float
var _delta_secs:float

func create_node(prefab, parent):
	var new_node = prefab.instantiate()
	parent.add_child(new_node)
	new_node.position = Vector2.ZERO;
	return new_node

func curr_secs():
	return _curr_secs;
	
func delta_secs():
	return _delta_secs;

var _result

func get_all_children(node, group = '') -> Array:
	_result = []
	_get_all_children_recursive(node, group)
	return _result

func _get_all_children_recursive(node, group = ''):
	if (group == '') or (node.is_in_group(group)):
		_result.append(node)

	for child in node.get_children():				
		_get_all_children_recursive(child, group)
	
func get_nodes_at(pos, group = '', collision_mask = 0):
	var point:PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	point.position = pos;
	point.collide_with_areas = true
	if collision_mask != 0:
		point.collision_mask = collision_mask
	var collisions = battle.get_world_2d().direct_space_state.intersect_point(point);
	if collisions == null:
		return([])
	
	var nodes = []
	for collision in collisions:
		var node = collision['collider'];
		if (group == '') or node.is_in_group(group):
			nodes.append(node)
	return nodes
