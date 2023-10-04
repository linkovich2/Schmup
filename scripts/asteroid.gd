extends StaticBody2D

var health = 20
var collision_damage = 2
var asteroid_particles = preload("res://scenes/asteroid_particles.tscn")
var smoke = preload("res://scenes/smoke.tscn")

func _ready():
	# @todo determine path of asteroid
	# determine drops
	# randomize asteroid size/graphic
	pass

func _process(delta):
	# @todo move in a random direction very slowly
	pass

func damage(amount):
	health -= amount
	if health <= 0:
		explode()

func collide():
	damage(20)

func explode():
	# @todo add explosion, particles, etc.
	var a = asteroid_particles.instantiate()
	a.position = position
	Game.add_child(a)
	for n in randi_range(0, 3):
		var s = smoke.instantiate()
		s.position = position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
		Game.add_child(s)
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$AudioStreamPlayer2D.play()
	$Timer.start()

func drops():
	# @todo drop stuff?
	pass


func _on_timer_timeout():
	queue_free()
