extends Node2D

@onready var creature_stats: Node2D = get_node('/root/main/battle/creature_stats')


func resolve():
    creature_stats.resolve()