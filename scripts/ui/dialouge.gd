extends PanelContainer

@onready var main: Node = get_node('/root/main')

@export var text_reveal_chars_per_sec:float = 10.0
@export var label:RichTextLabel
@export var nine_patch:NinePatchRect

var _text_start_sec: float = 0.0


func _process(_delta: float) -> void:
	if label.visible_ratio < 1.0:
		label.visible_characters = (main.curr_secs() - _text_start_sec) * text_reveal_chars_per_sec
	visible = label.text != ''

func set_texture_rect(new_rect):
	nine_patch.region_rect = new_rect

func send_text(new_text):
	_text_start_sec = main.curr_secs()
	label.text = new_text.replace('\\n', ' \n')
	label.visible_characters = 0

func clear_text():
	send_text('')
	label.visible_characters = -1

func progress():
	if label.visible_ratio < 1.0:
		label.visible_ratio = 1.0
		return false;
	else:
		return true

func set_battle_mode():
	var container:BoxContainer = get_parent()
	container.alignment = BoxContainer.ALIGNMENT_BEGIN

func set_world_mode():
	var container:BoxContainer = get_parent()
	container.alignment = BoxContainer.ALIGNMENT_CENTER
