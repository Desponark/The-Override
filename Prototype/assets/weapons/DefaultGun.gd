extends Node2D

export(PackedScene) var projectile
export(float) var projectileSpeed = 350

var projectileParent

func _process(delta):
	look_at(get_global_mouse_position())
	pass

func shoot():
	var newProjectile = projectile.instance()
	
	var globalDirection = global_transform.basis_xform(Vector2.RIGHT)
	newProjectile.setup(globalDirection.normalized() * projectileSpeed)
	
	projectileParent.add_child(newProjectile)
	newProjectile.global_position = $MuzzlePosition.global_position
