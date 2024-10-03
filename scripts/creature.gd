extends Node2D


@onready var hand: Node2D = get_node('/root/main/battle/creatures/hand')
@onready var battlefield: Node2D = get_node('/root/main/battle/creatures/battlefield')
@onready var main: Node = get_node('/root/main')
@onready var battle: Node2D = get_node('/root/main/battle')

var target_position
var state = ''
var index = -1


func _ready() -> void:
	add_to_group('creature');

func _process(delta: float) -> void:
	if target_position != Vector2.ZERO and global_position != target_position:
		var distance = global_position.distance_to(target_position)
		global_position = global_position.move_toward(target_position, delta * (distance + 300.0))

func move_to_hand():
	reparent(hand)
	hand.add_creature(self)

func move_to_battlefield():
	reparent(battlefield)
	battlefield.add_creature(self)

func set_target_position(new_target_position):
	for tile in main.get_all_children(battle, 'tile'):
		if tile.global_position == target_position:
			tile.unset_creature()
			if tile.is_in_group('battlefield_tile'):
				battlefield.remove_creature(self)
	target_position = new_target_position
	for tile in main.get_all_children(battle, 'tile'):
		if tile.global_position == target_position:
			tile.set_creature(self)

func unset_target_position():
	set_target_position(Vector2.ZERO)

func drop():
	var tiles = main.get_nodes_at(global_position, 'battlefield_tile')
	if not tiles.is_empty():
		move_to_battlefield()
	else:
		move_to_hand()
