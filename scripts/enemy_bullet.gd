extends Area2D

const SPEED = 300
var direction = Vector2()
var sparks_particles = preload("res://scenes/sparks_particles.tscn")
@export var damage = 1

func _process(delta):
	rotation += 0.1
	translate(direction * SPEED * delta)

func _on_timer_timeout():
	# @todo needs a sorta hit timeout animation, like maybe it fades?
	queue_free()

func _on_body_entered(body):
	if (body.is_in_group("player")):
		body.damage(damage) # damage player for one
	elif (body.is_in_group("obstacle")):
		body.damage(damage)
	
	var sparks = sparks_particles.instantiate()
	sparks.position = position
	Game.add_child(sparks)
	sparks.process_material.direction = Vector3(-direction.x, -direction.y, 0)
	sparks.emitting = true
	queue_free()
