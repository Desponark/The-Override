extends Node2D

export(PackedScene) var projectile
export(float) var projectileSpeed = 350

var projectileParent

var target
var stopTimer = false

func startShooting(body):
	target = body
	stopTimer = false
	$Timer.start()
	
func stopShooting():
	# stopTimer is used to delay stopping of the timer by 1 execution of the timer
	stopTimer = true

func shoot():
	var newProjectile = projectile.instance()
	
	var globalDirection = global_transform.basis_xform(Vector2.RIGHT)
	newProjectile.setup(globalDirection.normalized() * projectileSpeed)
	
	owner.add_child(newProjectile)
	newProjectile.global_position = $MuzzlePosition.global_position


func _on_Timer_timeout():
	look_at(target.global_position)
	shoot()
	if stopTimer:
		$Timer.stop()
