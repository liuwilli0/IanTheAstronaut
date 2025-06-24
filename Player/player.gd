extends CharacterBody2D

@export var move_speed = 800
@export var move_accel = 3200
@export var jump_speed = 1500

@onready var GravityRayCast = $GravityRayCast
@onready var MoveRayCast = $MoveRayCast
@onready var VelocityRayCast = $VelocityRayCast

var gravity = Vector2.ZERO
var move = Vector2.ZERO

func handle_input(delta):
	var direction = Input.get_axis("left", "right")
	var move_dir = Vector2.from_angle(rotation)
	move = move.move_toward(direction * move_dir * move_speed, move_accel * delta)
	if Input.is_action_pressed("up") && is_on_floor():
		gravity = up_direction * jump_speed

func _physics_process(delta):
	up_direction = GravityManager.get_up_direction(global_position)
	rotation = up_direction.angle() + PI / 2
	
	gravity += GravityManager.get_gravity(global_position) * delta
	handle_input(delta)
	velocity = gravity + move
	
	move_and_slide()
	if is_on_floor() or is_on_ceiling():
		gravity = Vector2.ZERO
	
	GravityRayCast.target_position = gravity
	MoveRayCast.target_position = move
	VelocityRayCast.target_position = velocity
	
	GravityRayCast.rotation = -rotation
	MoveRayCast.rotation = -rotation
	VelocityRayCast.rotation = -rotation
