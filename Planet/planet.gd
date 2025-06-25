class_name Planet
extends StaticBody2D

@onready var radius = $CollisionShape.shape.radius * scale.x
@export var density = 1
