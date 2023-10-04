extends Node2D

var enemy = preload("res://scenes/enemy_basic_pirate.tscn")
@export var axis = "n"
const DISTANCE_Y = 700
const DISTANCE_X = 1000

func _process(delta):
	position = Game.player.position
	if axis == "n":
		position.y = Game.player.position.y - DISTANCE_Y
	elif axis == "s": 
		position.y = Game.player.position.y + DISTANCE_Y
	elif axis == "w":
		position.x = Game.player.position.x - DISTANCE_X
	else:
		position.x = Game.player.position.x + DISTANCE_X

func spawn(resource, axis):
	var e = resource.instantiate()
	e.position = position
	if axis == "n" || axis == "s":
		e.position.x += randi_range(-500, 500)
	else:
		e.position.y += randi_range(-200, 200)
	Game.add_child(e)
	
