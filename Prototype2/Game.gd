extends Node2D

export var freezeSlow = 0.07
export var freezeTime = 0.3

func _ready():
	EventBus.connect("enemyWasHit", self, "freezeEngine")
	EventBus.connect("spawnProjectile", self, "spawnProjectile")
	
# this is for creating a nice hit stop / freeze effect for making melee hit feel more impactful
func freezeEngine():
	Engine.time_scale = freezeSlow
	yield(get_tree().create_timer(freezeTime * freezeSlow), "timeout")
	Engine.time_scale = 1

# adds any given projectile to the projectiles node
func spawnProjectile(newProjectile):
	$Projectiles.call_deferred("add_child", newProjectile)
