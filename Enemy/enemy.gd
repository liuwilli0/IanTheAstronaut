extends CharacterBody2D

@export var move_speed = 300

var gravity = Vector2.ZERO
var move = Vector2.ZERO
var direction = 1

func _physics_process(delta):
	up_direction = GravityManager.get_up_direction(global_position)
	rotation = up_direction.angle() - PI / 2
	
	gravity += GravityManager.get_planet_gravity(GravityManager.get_nearest_planet(global_position), global_position)
	move = direction * Vector2.from_angle(rotation) * move_speed
	velocity = gravity + move
	
	move_and_slide()
	if is_on_floor() or is_on_ceiling():
		gravity = Vector2.ZERO
	if is_on_wall():
		direction = -direction
