extends Node2D

export (PackedScene) var enemySpawn
export var minSpawnRate = 1
export var maxSpawnRate = 2

func _ready():
	randomize()

func spawnEnemy():
	var enemy = enemySpawn.instance()
	enemy.global_position = $Position2D.global_position
	EventBus.emit_signal("spawnEnemy", enemy)

func _on_Timer_timeout():
	spawnEnemy()
	$Timer.wait_time = rand_range(minSpawnRate, maxSpawnRate)
	
func startSpawner():
	# start spawning of enemies
	$Timer.start()
	pass

func stopSpawner():
	# stop spawning of enemies
	$Timer.stop()
	pass

# sockets functions
func socketIsCharging():
	startSpawner()
	
func socketFullyCharged():
	stopSpawner()
