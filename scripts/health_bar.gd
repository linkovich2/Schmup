extends CanvasLayer


func _ready():
	Game.health_bar.connect(_on_health_bar)

func _on_health_bar(n):
	$ProgressBar.value = n
	if (n < 100):
		$End.visible = false
	else:
		$End.visible = true
	
	if (n <= 0):
		$Begin.visible = false
	else:
		$Begin.visible = true
