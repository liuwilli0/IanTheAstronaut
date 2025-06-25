class_name Enemy
extends CharacterBody2D

@export var move_speed = 300

@onready var planet = get_parent()

var gravity = Vector2.ZERO
var move = Vector2.ZERO
var direction = 1

func die():
	queue_free()

func _physics_process(delta):
	up_direction = GravityManager.get_up_direction(global_position)
	rotation = up_direction.angle() - PI / 2
	
	gravity += GravityManager.get_planet_gravity(planet, global_position) * delta
	move = direction * Vector2.from_angle(rotation) * move_speed
	velocity = gravity + move
	
	move_and_slide()
	if is_on_floor() or is_on_ceiling():
		gravity = Vector2.ZERO
	if is_on_wall():
		direction = -direction

func _on_hitbox_area_entered(area):
	var parent = area.get_parent()
	if parent is Player:
		var rotated_distance = global_position.distance_to(planet.global_position)
		var parent_rotated_distance = parent.global_position.distance_to(planet.global_position)
		if GravityManager.get_nearest_planet(parent.position) == planet and parent_rotated_distance - parent.size.y / 2 > rotated_distance:
			parent.enemy_bounce()
			die()
		else:
			parent.die()
