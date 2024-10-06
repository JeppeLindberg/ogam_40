extends Node2D

@export var stats_prefab: PackedScene
@export var win_prefab: PackedScene
@export var tie_prefab: PackedScene
@export var loss_prefab: PackedScene

@onready var creatures:Node2D = get_node('/root/main/battle/creatures')
@onready var enemy:Node2D = get_node('/root/main/battle/creatures/enemy')
@onready var battlefield:Node2D = get_node('/root/main/battle/creatures/battlefield')
@onready var main:Node = get_node('/root/main')
@onready var win_loss_mark:Node2D = get_node('/root/main/battle/measures/win_loss_mark')
@onready var effects:Node2D = get_node('/root/main/battle/effects')

var dirty = false;


func _process(_delta: float) -> void:

	if dirty:
		_recalculate_state()
		dirty = false;

func _recalculate_state():
	for child in get_children():
		child.queue_free()

	for creature in main.get_all_children(creatures, 'creature'):
		var stats = main.create_node(stats_prefab, self)
		stats.global_position = creature.target_position
		stats.calculate(creature)
		
func _get_child_at_pos(pos):
	for child in get_children():
		if child.global_position == pos:
			return(child)
	
	return(null)

var _score = 0

func resolve():
	_score = 0
	var matchups = []

	for x in range(6):
		matchups.append([null, null])

	for enemy_creature in main.get_all_children(enemy, 'creature'):
		matchups[enemy_creature.index][0] = enemy_creature

	for player_creature in main.get_all_children(battlefield, 'creature'):
		matchups[player_creature.index][1] = player_creature
	
	for matchup in matchups:
		if (matchup[0] == null) and (matchup[1] == null):
			continue;
		
		if (matchup[0] == null) and (matchup[1] != null):
			_mark_win(matchup);
			continue;
		
		if (matchup[0] != null) and (matchup[1] == null):
			_mark_loss(matchup);
			continue;
		
		if (matchup[0] != null) and (matchup[1] != null):
			var enemy_stats = _get_child_at_pos(matchup[0].target_position)
			var player_stats = _get_child_at_pos(matchup[1].target_position)
			var matchup_score = 0

			if (player_stats.gleam > enemy_stats.gleam):
				matchup_score += 1
			if (player_stats.gleam < enemy_stats.gleam):
				matchup_score -= 1

			if (player_stats.insight > enemy_stats.insight):
				matchup_score += 1
			if (player_stats.insight < enemy_stats.insight):
				matchup_score -= 1

			if matchup_score > 0:
				_mark_win(matchup)
				continue
			if matchup_score < 0:
				_mark_loss(matchup)
				continue
			if matchup_score == 0:
				_mark_tie(matchup)
				continue
	
	if _score > 0:
		print('continue')


func _mark_win(matchup):
	_score += 1
	var mark_pos = _get_mark_pos(matchup)
	var mark_win = main.create_node(win_prefab, effects)
	mark_win.global_position = mark_pos

func _mark_loss(matchup):
	_score -= 1
	var mark_pos = _get_mark_pos(matchup)
	var mark_loss = main.create_node(loss_prefab, effects)
	mark_loss.global_position = mark_pos

func _mark_tie(matchup):
	var mark_pos = _get_mark_pos(matchup)
	var mark_tie = main.create_node(tie_prefab, effects)
	mark_tie.global_position = mark_pos

func _get_mark_pos(matchup):
	var mark_pos = Vector2.ZERO
	var count = 0
	for i in range(2):
		if matchup[i] != null:
			count += 1
			mark_pos += matchup[i].target_position

	if count == 0:
		return(win_loss_mark.global_position)

	mark_pos = mark_pos/count
	return(Vector2(mark_pos.x, win_loss_mark.global_position.y))

func clean_up():
	for child in get_children():
		child.queue_free()
