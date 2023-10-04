extends Node

var spawners
var last_chosen_spawner
var waves = []
var wave_index = 0
var level
var basic_pirate = preload("res://scenes/enemy_basic_pirate.tscn")
var asteroid = preload("res://scenes/asteroid.tscn")

func _ready():
	spawners = get_tree().get_nodes_in_group("spawner")
	
	waves.append({
		"wait_time": 0.0,
		"enemies":  [
			{ "count": 2, "enemy": basic_pirate, "grouped": true }
		]
	})
	
	waves.append({
		"wait_time": 5.0,
		"enemies":  [
			{ "count": 1, "enemy": basic_pirate, "grouped": true },
			{ "count": 2, "enemy": basic_pirate, "grouped": true }
		]
	})
	
	waves.append({
		"wait_time": 4.0,
		"enemies":  [
			{ "count": 1, "enemy": basic_pirate, "grouped": false },
			{ "count": 1, "enemy": asteroid, "grouped": false }
		]
	})
	
	waves.append({
		"wait_time": 10.0,
		"enemies":  [
			{ "count": 4, "enemy": basic_pirate, "grouped": true },
			{ "count": 1, "enemy": asteroid, "grouped": false }
		]
	})
	
	waves.append({
		"wait_time": 2.0,
		"enemies":  [
			{ "count": 2, "enemy": basic_pirate, "grouped": false }
		]
	})

func process_wave():
	if !(range(waves.size()).has(wave_index)):
		wave_index = 0 # start over for now @todo
	
	$Timer.wait_time = waves[wave_index]["wait_time"]
	
	for group in waves[wave_index]["enemies"]:
		spawn(group["enemy"], group["count"], group["grouped"])
	
	wave_index += 1
	
	$Timer.start()

func spawn(type, count, group):
	# @todo store last spawner to spawn one and choose one until it's different?
	var i = 0
	var spawner = random_spawner()
	
	while i < count:
		if !group:
			spawner = random_spawner()
		spawner.spawn(type, spawner.axis)
		i += 1

func random_spawner():
	var spawner = spawners[randi() % spawners.size()]
	while spawner == last_chosen_spawner:
		spawner = random_spawner()
	return spawner

func _on_timer_timeout():
	process_wave()
