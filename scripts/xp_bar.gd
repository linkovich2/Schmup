extends CanvasLayer


func _ready():
	Game.xp_bar.connect(_on_xp_bar)

func _on_xp_bar(amount):
	$ProgressBar.value = amount
