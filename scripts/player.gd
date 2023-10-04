extends CharacterBody2D

@export var max_speed = 100
@export var acceleration_rate = 10
@export var max_health = 10.0
var health = max_health
var xp = 0.0
var xp_to_level = 10.0
var level = 1
@export var friction = 0.01
var bullet = preload("res://scenes/simple_bullet.tscn")
var dead = false

signal health_updated(value)

func _ready():
	Game.player = self
	
func _process(delta):
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("enemy") || collision.get_collider().is_in_group("obstacle"):
			collision.get_collider().collide()
			damage(collision.get_collider().collision_damage)

func _physics_process(delta):
	var flash = max($Sprite2D.material.get_shader_parameter("flashState") - 0.1, 0)
	$Sprite2D.material.set_shader_parameter("flashState", flash)
	
	var direction = (get_global_mouse_position() - position).normalized()
	rotation = direction.angle()

	# @todo direction tweaks, maybe a roll?
	# @todo shield, hull health upgrades?
	# boosting? super boost power-ups? shader can create faded versions
	
	if (Input.is_action_just_pressed("move_up")):
		$BoostSound.play()
	
	if (Input.is_action_just_released("move_up")):
		velocity += direction * acceleration_rate
		$EngineHum.stop()
	
	if (Input.is_action_pressed("move_up")):
		$Sprite2D/Booster/Boost/AnimationPlayer.play()
		if (!$EngineHum.playing):
			$EngineHum.play()
		velocity += direction * acceleration_rate
	
	if (Input.is_action_pressed("shoot") && $ShotCooldown.is_stopped()):
		var b = bullet.instantiate()
		b.direction = direction
		b.position = position + direction * 20 # @todo offset this and alternate cannons
		b.rotation = direction.angle()
		get_parent().add_child(b)
		$GunSound.play()
		$ShotCooldown.start()
	
	var brakes = 0.0
	if (Input.is_action_pressed("move_down")):
		brakes = 0.02
	
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
	move_and_slide()
	
	velocity.x = lerp(velocity.x, 0.0, friction + brakes)
	velocity.y = lerp(velocity.y, 0.0, friction + brakes)

func reset_damage_visibility():
	$Sprite2D/Damage_1.visible = false
	$Sprite2D/Damage_2.visible = false
	$Sprite2D/Damage_3.visible = false

func damage(amount):
	update_health(health - amount)
	$ImpactSound.play()
		
	$Sprite2D.material.set_shader_parameter("flashState", 0.8)

func update_health(amount):
	health = amount
	var health_percent = health / max_health
	Game.update_health_bar(health_percent * 100)
	reset_damage_visibility()
	if (health_percent <= 0.7 && health_percent > 0.5):
		$Sprite2D/Damage_1.visible = true
	elif (health_percent <= 0.5 && health_percent > 0.2):
		$Sprite2D/Damage_2.visible = true
	elif (health_percent <= 0.2):
		$Sprite2D/Damage_3.visible = true
	if health <= 0 && !dead:
		dead = true
		get_parent().game_over()
	
func add_xp(amount):
	xp += amount
	if xp >= xp_to_level:
		level_up()
	Game.update_xp_bar((xp/xp_to_level) * 100)

func level_up():
	update_health(max_health)
	$ShotCooldown.wait_time = $ShotCooldown.wait_time/1.5
	xp_to_level = xp_to_level * (level+1)
	xp = 0
	level += 1
	
