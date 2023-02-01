extends Node2D

export (PackedScene) var enemySpawn
export var minSpawnRate = 3
export var maxSpawnRate = 6


func _ready():
	randomize()

func spawnEnemy():
	var enemy = enemySpawn.instance()
	enemy.global_position = $Position2D.global_position
	EventBus.emit_signal("spawnEnemy", enemy)

func _on_Timer_timeout():
	spawnEnemy()
	
func startSpawner():
	# start spawning of enemies
	$Timer.start(rand_range(minSpawnRate, maxSpawnRate))
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
