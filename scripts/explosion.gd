extends AnimatedSprite2D

var smoke = preload("res://scenes/smoke.tscn")

func _ready():
	rotation = randi_range(-180, 180)
	$ExplosionSound.play()
	for n in randi_range(0, 3):
		var s = smoke.instantiate()
		s.position = position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
		Game.add_child(s)

func _on_animation_finished():
	$Timer.start()

func _on_timer_timeout():
	queue_free()

