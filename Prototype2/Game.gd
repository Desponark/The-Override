extends Node2D

export var freezeSlow = 0.07
export var freezeTime = 0.3



func _ready():
	# warning-ignore-all:RETURN_VALUE_DISCARDED
	EventBus.connect("enemyWasHit", self, "freezeEngine")
	EventBus.connect("spawnProjectile", self, "spawnProjectile")
	EventBus.connect("spawnEnemy", self, "spawnEnemy")
	EventBus.connect("spawnLoot", self, "spawnLoot")
	
	# setup references
	

# close game if esc is pressed (for testing)
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# this is for creating a nice hit stop / freeze effect for making melee hit feel more impactful
func freezeEngine():
	Engine.time_scale = freezeSlow
	# TODO: check if should be implemented differently
	# TODO: BUG: -> in rare cases the timer can get deleted if the scene gets restarted
	# 				which leads to permanent game slow down
	#				(atleast I suspect that is the case, I was not able to reliably recreate the bug)
	yield(get_tree().create_timer(freezeTime * freezeSlow), "timeout")
	Engine.time_scale = 1

# adds any given projectile to the projectiles node
func spawnProjectile(newProjectile):
	$Projectiles.call_deferred("add_child", newProjectile)
	
# adds any given enemies to the enemies node
func spawnEnemy(newEnemy):
	$Enemies.add_child(newEnemy)

# adds any given "loot" to the loot node
func spawnLoot(newLoot):
	$Loot.add_child(newLoot)
