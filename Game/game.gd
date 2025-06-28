extends Node2D

@onready var level_complete = $LevelComplete
@onready var levels = $Levels.get_children()
@onready var gravity_manager = $GravityManager

var level = 0

func complete_level():
	level_complete.visible = true
	if level >= len(levels) - 1:
		level_complete.get_child(1).visible = false
		level_complete.get_child(0).text = "You Win!"
		await get_tree().create_timer(3).timeout
		level_complete.visible = false

func _ready():
	gravity_manager.planets = levels[0].get_children()
	for level in levels.slice(1):
		level.position = Vector2(100000, 100000)
		level.visible = false

func _on_button_pressed():
	levels[level].visible = false
	levels[level].process_mode = PROCESS_MODE_DISABLED
	levels[level].position = Vector2(100000, 100000)
	level += 1
	level_complete.visible = false
	gravity_manager.planets = levels[level].get_children()
	levels[level].visible = true
	levels[level].process_mode = PROCESS_MODE_INHERIT
	levels[level].position = Vector2(0, 0)
