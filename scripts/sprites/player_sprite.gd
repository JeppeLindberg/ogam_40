extends Sprite2D

@onready var main: Node = get_node('/root/main')

@export var animation_frames_per_sec: float = 10.0

@export var walk_up_rect_cycle:Array[Rect2]
@export var walk_down_rect_cycle:Array[Rect2]
@export var walk_left_rect_cycle:Array[Rect2]
@export var walk_right_rect_cycle:Array[Rect2]

var _animation_changed_sec = 0.0
var _current_anim = 'walk_down'
var _play_animation = false


func _process(_delta: float) -> void:
	if not _play_animation:
		return;

	var frame_index = int((main.curr_secs() - _animation_changed_sec) * animation_frames_per_sec)

	if _current_anim == 'walk_up':
		frame_index = frame_index % len(walk_up_rect_cycle)
		region_rect = walk_up_rect_cycle[frame_index]
	if _current_anim == 'walk_down':
		frame_index = frame_index % len(walk_down_rect_cycle)
		region_rect = walk_down_rect_cycle[frame_index]
	if _current_anim == 'walk_right':
		frame_index = frame_index % len(walk_right_rect_cycle)
		region_rect = walk_right_rect_cycle[frame_index]
	if _current_anim == 'walk_left':
		frame_index = frame_index % len(walk_left_rect_cycle)
		region_rect = walk_left_rect_cycle[frame_index]

func walk_up():
	_animation_changed_sec = main.curr_secs()
	_current_anim = 'walk_up'
	_play_animation = true

func walk_down():
	_animation_changed_sec = main.curr_secs()
	_current_anim = 'walk_down'
	_play_animation = true

func walk_left():
	_animation_changed_sec = main.curr_secs()
	_current_anim = 'walk_left'
	_play_animation = true

func walk_right():
	_animation_changed_sec = main.curr_secs()
	_current_anim = 'walk_right'
	_play_animation = true

func look_up():
	region_rect = walk_up_rect_cycle[0]
	_play_animation = false

func look_down():
	region_rect = walk_down_rect_cycle[0]
	_play_animation = false

func look_left():
	region_rect = walk_left_rect_cycle[0]
	_play_animation = false

func look_right():
	region_rect = walk_right_rect_cycle[0]
	_play_animation = false
