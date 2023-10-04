extends Area2D

const SPEED = 800
var direction = Vector2()
var hit_graphic = preload("res://scenes/simple_bullet_hit.tscn")
var sparks_particles = preload("res://scenes/sparks_particles.tscn")

func _process(delta):
	translate(direction * SPEED * delta)

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if (body.is_in_group("obstacle")):
		body.damage(5)
		hit() 
	elif (body.is_in_group("enemy")):
		body.damage(5)
		hit()

func hit():
	var h = hit_graphic.instantiate()
	h.position = position
	Game.add_child(h)
	var sparks = sparks_particles.instantiate()
	sparks.position = position
	Game.add_child(sparks)
	sparks.process_material.direction = Vector3(-direction.x, -direction.y, 0)
	sparks.emitting = true
	
	queue_free()
