extends Node2D

@onready var main:Node = get_node('/root/main')
@onready var gleam_text:Label = get_node('gleam/text')
@onready var insight_text:Label = get_node('insight/text')

var gleam = 0
var insight = 0


func calculate(creature):
	gleam = creature.base_gleam
	insight = creature.base_insight

	gleam_text.text = str(gleam)
	insight_text.text = str(insight)
