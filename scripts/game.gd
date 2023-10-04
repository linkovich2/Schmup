extends Node

var player
var score = 0

signal kill(n)
signal health_bar(n)
signal xp_bar(n)

func _ready():
	get_tree().change_scene_to_file("res://scenes/play_screen.tscn")
	# @todo load up main menu instead

func increment_score():
	score += 1
	kill.emit(score)

func update_health_bar(amount):
	health_bar.emit(amount)

func update_xp_bar(amount):
	xp_bar.emit(amount)
