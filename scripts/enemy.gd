extends CharacterBody2D

var target_direction = Vector2()
var bullet = preload("res://scenes/enemy_bullet.tscn")
var explosion = preload("res://scenes/explosion.tscn")
var xp_star = preload("res://scenes/xp_star.tscn")
var collision_damage = 3
var explosion_particles = preload("res://scenes/explosion_particles.tscn")
const SPEED = 75
@export var accuracy = 50 # less is more
@export var health = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = randf_range(2, 2.5) # stagger shots
	set_target_direction(0)

func _process(delta):
	set_target_direction(accuracy)
	var flash = max($Sprite2D.material.get_shader_parameter("flashState") - 0.1, 0)
	$Sprite2D.material.set_shader_parameter("flashState", flash)
	$Wing1.material.set_shader_parameter("flashState", flash)
	$Wing2.material.set_shader_parameter("flashState", flash)

func _physics_process(delta):
	look_at(Game.player.position)
	velocity = target_direction * SPEED
	move_and_slide()
	
func set_target_direction(offset):
	var offset_direction = (Game.player.position - position)
	var randomized_offset = randi_range(-offset, offset)
	offset_direction = Vector2(offset_direction.x + randomized_offset, offset_direction.y + randomized_offset)
	target_direction = offset_direction.normalized()

func collide():
	damage(10)

func damage(amount):
	# @todo damage shield, shield recharge?
	# @todo floating damage number?
	flash()
	health -= amount
	if (health <= 0):
		# @todo crashing animation, spin out then explode, leaving smoke trail
		# explosion
		load_at_position(explosion)
		load_at_position(xp_star)
		
		var i = explosion_particles.instantiate()
		i.position = position
		Game.add_child(i)
		i.emitting = true
		
		Game.increment_score()
		queue_free() # for now

func flash():
	$Sprite2D.material.set_shader_parameter("flashState", 0.8)
	$Wing2.material.set_shader_parameter("flashState", 0.8)
	$Wing1.material.set_shader_parameter("flashState", 0.8)

func load_at_position(resource):
	var i = resource.instantiate()
	i.position = position
	Game.add_child(i)

func _on_timer_timeout():
	var distance = position.distance_to(Game.player.position)
	if distance > 500 || distance < 100:
		return
		
	var b = bullet.instantiate()
	b.direction = target_direction
	b.position = position + target_direction * 40 # @todo offset this and alternate cannons
	b.rotation = target_direction.angle()
	$Gunshot.play()
	get_parent().add_child(b)
