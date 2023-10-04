extends CanvasLayer

func _ready():
	Game.kill.connect(_on_kill)

func _on_kill(score):
	$Label.text = "Kills: " + str(score)
