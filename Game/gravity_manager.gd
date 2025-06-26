extends Node

var planets

func get_nearest_planet(position):
	var nearest_planet
	var distance_to_nearest_planet = INF
	for planet in planets:
		var distance_to_planet = position.distance_to(planet.global_position) - planet.radius
		if distance_to_planet < distance_to_nearest_planet:
			nearest_planet = planet
			distance_to_nearest_planet = distance_to_planet
	return nearest_planet

func get_up_direction(position):
	return get_nearest_planet(position).global_position.direction_to(position)

func get_planet_gravity(planet, position):
	var planet_mass = planet.density * PI * planet.radius * planet.radius
	var body_to_planet = planet.global_position - position
	return 1000 * body_to_planet.normalized() * planet_mass / body_to_planet.length_squared()

func get_gravity(position):
	var gravity = Vector2.ZERO
	for planet in planets:
		gravity += get_planet_gravity(planet, position)
	return gravity

func _on_planets_ready():
	planets = $"../Planets".get_children()
