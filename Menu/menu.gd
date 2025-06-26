extends Control

@onready var main = $"/root/Main"
@onready var UI = $UI
@onready var animated_sprite = $AnimatedSprite

var sway_amplitude = 10
var sway_speed = 0.5
var base_position = Vector2.ZERO
var time_passed = 0.0

func _ready():
	base_position = UI.position
	animated_sprite.play()

func _process(delta):
	time_passed += delta
	var offset_y = sin(time_passed * PI * 2 * sway_speed) * sway_amplitude
	UI.position.y = base_position.y + offset_y

func _on_button_pressed():
	main.start_game()
