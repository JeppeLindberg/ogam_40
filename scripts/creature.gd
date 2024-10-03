extends Node2D


@onready var hand: Node2D = get_node('/root/main/battle/creatures/hand')
@onready var battlefield: Node2D = get_node('/root/main/battle/creatures/battlefield')
@onready var enemy: Node2D = get_node('/root/main/battle/creatures/enemy')
@onready var main: Node = get_node('/root/main')
@onready var battle: Node2D = get_node('/root/main/battle')
@onready var creature_stats: Node2D = get_node('/root/main/battle/creature_stats')

@export var base_gleam: int = 1
@export var base_insight: int = 1

var target_position = Vector2.ZERO
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

func move_to_enemy():
	reparent(enemy)
	enemy.add_creature(self)

func set_target_position(new_target_position):
	var from_battlefield = false
	var to_battlefield = false

	for tile in main.get_all_children(battle, 'tile'):
		if tile.global_position == target_position:
			tile.unset_creature()
			if tile.is_in_group('battlefield_tile'):
				from_battlefield = true
	target_position = new_target_position
	for tile in main.get_all_children(battle, 'tile'):
		if tile.global_position == target_position:
			tile.set_creature(self)
			if tile.is_in_group('battlefield_tile'):
				to_battlefield = true

	if from_battlefield and not to_battlefield:
		battlefield.remove_creature(self)

	creature_stats.dirty = true;

func unset_target_position():
	set_target_position(Vector2.ZERO)

func drop():
	var tiles = main.get_nodes_at(global_position, 'battlefield_tile')
	if not tiles.is_empty():
		move_to_battlefield()
	else:
		move_to_hand()
