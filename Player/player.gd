class_name Player
extends CharacterBody2D

@export var move_speed = 800
@export var move_accel = 3200
@export var jump_speed = 800
@export var thrust_speed = 400
@export var thrust_accel = 4000
@export var thrust_usage_rate = 1

@onready var background = $"../Background"
@onready var bullet_scene = preload("res://Bullet/bullet.tscn")
@onready var spawn_position = position
@onready var gravity_manager = $"/root/Main/Game/GravityManager"
@onready var jump_timer = $JumpTimer
@onready var thrust_bar = $ThrustBar
@onready var animated_sprite = $AnimatedSprite
@onready var size = $CollisionShape.shape.size
@onready var gravity_ray_cast = $Vectors/GravityRayCast
@onready var move_ray_cast = $Vectors/MoveRayCast
@onready var velocity_ray_cast = $Vectors/VelocityRayCast

var gravity = Vector2.ZERO
var gravity_strength = 1
var move = Vector2.ZERO

func die():
	thrust_bar.visible = false
	animated_sprite.scale.x = 2
	animated_sprite.scale.y = 2
	animated_sprite.play("Death", 8)
	set_physics_process(false)
	await animated_sprite.animation_finished
	reset()

func reset():
	thrust_bar.visible = true;
	animated_sprite.scale.x = 4
	animated_sprite.scale.y = 4
	position = spawn_position
	set_physics_process(true)

func enemy_bounce(enemy):
	gravity = enemy.up_direction * thrust_speed

func handle_movement(delta):
	var move_input = Input.get_axis("Left", "Right")
	var move_dir = Vector2.from_angle(rotation)
	move = move.move_toward(move_input * move_dir * move_speed, move_accel * delta)
	
	if Input.is_action_just_pressed("RMB"):
		var mouse_position = get_viewport().get_mouse_position() - get_viewport().get_visible_rect().size / 2
		var bullet = bullet_scene.instantiate()
		bullet.position = position + Vector2(70 if animated_sprite.flip_h else -70, -50).rotated(rotation)
		bullet.look_at(mouse_position + bullet.position)
		bullet.rotate(rotation)
		get_tree().root.add_child(bullet)
	
	var thrust_input = Input.get_axis("Down", "Up")
	if thrust_input != 0 and thrust_bar.value > 0:
		if animated_sprite.animation != "Jump":
			animated_sprite.play("Jump")
		gravity = gravity.move_toward(thrust_input * up_direction * thrust_speed, thrust_accel * delta)
		thrust_bar.value -= thrust_usage_rate
	
	if Input.is_action_pressed("Jump"):
		if animated_sprite.animation != "Jump":
			animated_sprite.play("Jump")
	
	var vertical_velocity = velocity.dot(up_direction)
	if Input.is_action_pressed("Jump") and is_on_floor():
		gravity = up_direction * jump_speed
		gravity_strength = 0.4
	if not Input.is_action_pressed("Jump") or vertical_velocity < 0:
		gravity_strength = 1
	
	var horizontal_velocity = move.dot(move_dir)
	if horizontal_velocity != 0:
		animated_sprite.flip_h = horizontal_velocity > 0
	
	if is_on_floor():
		thrust_bar.value = 100
		if move == Vector2.ZERO:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Walk", horizontal_velocity * delta * 0.1)
	
	if Input.is_action_just_pressed("Reset"):
		position = spawn_position

func _physics_process(delta):
	up_direction = gravity_manager.get_up_direction(global_position)
	rotation = up_direction.angle() + PI / 2
	
	gravity += gravity_manager.get_gravity(global_position) * gravity_strength * delta
	handle_movement(delta)
	velocity = gravity + move
	
	move_and_slide()
	if is_on_floor() or is_on_ceiling():
		gravity = Vector2.ZERO
	
	gravity_ray_cast.target_position = gravity
	move_ray_cast.target_position = move
	velocity_ray_cast.target_position = velocity
