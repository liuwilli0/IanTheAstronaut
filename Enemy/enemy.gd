class_name Enemy
extends CharacterBody2D

@export var move_speed = 300

@onready var gravity_manager = $"/root/Main/Game/GravityManager"
@onready var planet = get_parent()
@onready var player = $"/root/Main/Game/Player"

var gravity = Vector2.ZERO
var move = Vector2.ZERO
var direction = 1

func die(): 
	player.enemy_count -= 1
	if player.enemy_count <= 0:
		player.get_parent().complete_level()
	queue_free()

func _physics_process(delta):
	up_direction = gravity_manager.get_up_direction(global_position)
	rotation = up_direction.angle() - PI / 2
	
	gravity += gravity_manager.get_planet_gravity(planet, global_position) * delta
	move = direction * Vector2.from_angle(rotation) * move_speed
	velocity = gravity + move
	
	move_and_slide()
	if is_on_floor() or is_on_ceiling():
		gravity = Vector2.ZERO
	if is_on_wall():
		direction = -direction

func _ready():
	player.enemy_count += 1

func _on_hitbox_area_entered(area):
	var parent = area.get_parent()
	if parent is Player:
		var vertical_position = global_position.distance_to(planet.global_position)
		var parent_vertical_position = parent.global_position.distance_to(planet.global_position)
		if parent_vertical_position - parent.size.y / 2 > vertical_position:
			parent.enemy_bounce(self)
			die()
		else:
			parent.die()
