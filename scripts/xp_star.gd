extends Area2D

@export var value = 1
var velocity = Vector2()
var dead = false

func _ready():
	rotation = randi_range(-180, 180)

func _physics_process(delta):
	var distance = position.distance_to(Game.player.position)
	if distance < 200:
		position += (Game.player.position - position).normalized() * 2

func _on_body_entered(body):
	if (body.is_in_group("player") && !dead):
		body.add_xp(value)
		$AudioStreamPlayer2D.play()
		$Sprite2D.visible = false
		$Timer.start()
		dead = true

func _on_timer_timeout():
	queue_free()
