extends Position2D

export (PackedScene) var enemySpawn

func spawn_rock():
	randomize()
	
	var enemy = enemySpawn.instance()
	
	# Set spawn location for rocks to RockSpawnPoint
	var enemySpawnLocation = $Spawner.position
	enemy.position = enemySpawnLocation
	
	# Spawn new rock if a randomly generated number is greater than the given value below
	if randf() > 0.5:
		add_child(enemy)
