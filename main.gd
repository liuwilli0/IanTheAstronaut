extends Node2D

@onready var canvas = $CanvasLayer
@onready var menu = $CanvasLayer/Menu
@onready var game = $Game

func start_game():
	canvas.follow_viewport_enabled = true
	menu.visible = false
	game.visible = true
	game.process_mode = Node.PROCESS_MODE_INHERIT
