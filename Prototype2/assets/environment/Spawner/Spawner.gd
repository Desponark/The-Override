extends Node2D

export (PackedScene) var enemySpawn
export var minSpawnRate = 1
export var maxSpawnRate = 2

func _ready():
	randomize()
	
#func _physics_process(delta):
#	spawn_enemy()

func spawn_enemy():
	var enemy = enemySpawn.instance()
	# Set spawn location for enemy to enemySpawnPoint
	var enemySpawnLocation = $Position2D.position
	enemy.position = enemySpawnLocation
	# Spawn new enemy if a randomly generated number is greater than the given value below
	add_child(enemy)

func _on_Timer_timeout():
	spawn_enemy()
	$Timer.wait_time = rand_range(minSpawnRate, maxSpawnRate)
	
func _on_SocketActivated():
	# start spawning of enemies
	$Timer.start()
	pass

func _on_SocketFullyCharged():
	# stop spawning of enemies
	$Timer.stop()
	pass
