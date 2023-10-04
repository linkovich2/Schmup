extends Node

var explosion = preload("res://scenes/explosion.tscn")
var explosion_particles = preload("res://scenes/explosion_particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func game_over():
	get_tree().paused = true
	var e = explosion.instantiate()
	var i = explosion_particles.instantiate()
	e.position = Game.player.position
	i.position = Game.player.position
	Game.add_child(e)
	Game.add_child(i)
	i.emitting = true
	Game.player.get_node("Sprite2D").visible = false
	$GameOverTimer.start()

func _on_game_over_timer_timeout():
	$GameOverScreen.visible = true
	$GameOverSound.play()

func _on_round_timer_timeout():
	# made it to the end of the round!
	# @todo do something here?
	print("We won!")
