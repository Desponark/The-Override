extends Node2D

export(PackedScene) var projectile
export(float) var projectileSpeed = 350

var target

func startShooting(body):
	target = body
	shoot(target)
	$Timer.start()
	
func stopShooting():
	$Timer.stop()
	target = null
	
func shoot(target):
	look_at(target.global_position)	
	
	var newProjectile = projectile.instance()
	
	var globalDirection = global_transform.basis_xform(Vector2.RIGHT)
	newProjectile.setup(globalDirection.normalized() * projectileSpeed)
	newProjectile.global_position = $MuzzlePosition.global_position
	EventBus.emit_signal("spawnProjectile", newProjectile)
	
func _on_Timer_timeout():
	if target == null:
		stopShooting()
		return
	shoot(target)
