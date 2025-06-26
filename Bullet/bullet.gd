class_name Bullet
extends RigidBody2D

@export var bullet_speed = 1000

@onready var gravity_manager = $"/root/Main/Game/GravityManager"
@onready var timer = $Timer

func _physics_process(delta):
	# rotation = gravity_manager.get_up_direction(global_position).angle() + PI / 2
	apply_central_force(gravity_manager.get_gravity(global_position) * 0.2)

func _ready():
	# apply_central_impulse(gravity_manager.get_up_direction(global_position).rotated(PI / 2) * bullet_speed)
	timer.start()
	apply_central_impulse(Vector2.from_angle(rotation) * bullet_speed)

func _on_hitbox_area_entered(area):
	var parent = area.get_parent()
	if parent is Planet:
		queue_free()
	if parent is Enemy:
		parent.die()
		queue_free()

func _on_timer_timeout():
	queue_free()
