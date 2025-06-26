extends Node2D

@onready var level_complete = $LevelComplete

func complete_level():
	print("Level complete")
	level_complete.visible = true
