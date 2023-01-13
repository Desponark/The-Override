extends Node2D

export (PackedScene) var enemySpawn
export var minSpawnRate = 0.5
export var maxSpawnRate = 1.5
export(NodePath) var spawnerTarget = null
export(NodePath) var signalNode

func _ready():
	randomize()
	var node = get_node_or_null(signalNode)
	if node != null:
		node.connect("socketActivated", self, "_on_SocketActivated")
		node.connect("socketFullyCharged", self, "_on_SocketFullyCharged")
	pass


func spawn_enemy():
	var enemy = enemySpawn.instance()
	# Set spawn location for enemy to enemySpawnPoint
	enemy.setup(get_node(spawnerTarget).global_position)		
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
