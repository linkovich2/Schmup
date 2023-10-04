extends Sprite2D

func _ready():
	rotation = randi_range(-180, 180)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
