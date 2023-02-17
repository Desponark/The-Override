extends "res://assets/environment/doors/SpawnerDoor.gd"

func lock(seconds):
	isLocked = true
	$Sprite.self_modulate = Color(1,0,0)
	
	yield(get_tree().create_timer(seconds), "timeout")
	isLocked = false
	$Sprite.self_modulate = Color(1,1,1)
