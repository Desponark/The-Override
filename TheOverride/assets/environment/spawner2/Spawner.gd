extends Node2D

export (PackedScene) var enemySpawn
export var autostart = false
export var minSpawnRate = 3
export var maxSpawnRate = 6
export var waveSpawnAmount = 5
export var waveCooldown = 20
var waveSpawns = 0
enum MOVEDIRECTIONS {NONE = 0, LEFT = -1, RIGHT = 1}
export(MOVEDIRECTIONS) var initialMoveDirection = MOVEDIRECTIONS.NONE

func _ready():
	randomize()
	if autostart:
		startSpawner()

func spawnEnemy():
	var enemy = enemySpawn.instance()
	enemy.global_position = $Position2D.global_position
	if enemy.has_method("setInitialMoveDirection"):
		enemy.setInitialMoveDirection(initialMoveDirection)
	EventBus.emit_signal("spawnEnemy", enemy)

func _on_Timer_timeout():
	if waveSpawns < waveSpawnAmount:
		spawnEnemy()
		waveSpawns += 1
		$Timer.wait_time = rand_range(minSpawnRate, maxSpawnRate)
	else:
		waveSpawns = 0
		$Cooldown.start(waveCooldown)
		$Timer.stop()

func startSpawner():
	$Timer.start(rand_range(minSpawnRate, maxSpawnRate))

func stopSpawner():
	$Timer.stop()
	$Cooldown.stop()
	
func _on_Cooldown_timeout():
	startSpawner()

# sockets functions
func socketIsCharging():
	startSpawner()
	
func socketFullyCharged():
	stopSpawner()
