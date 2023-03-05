extends RigidBody2D


export var healAmount = 25
export var acceleration = 20
var player = null
var speed = 0

func _integrate_forces(state):
	if player:
		speed += acceleration
		state.linear_velocity = global_position.direction_to(player.getHealthBarPosition()) * speed

func _on_Area2D_body_entered(body):
	player = body
	$Collect.play()
	# disable all physics collisions if setting collision shape to disabled it wants to be called deferred
	$CollisionShape2D.set_deferred("disabled", true)
	# disable possible player collisions
	$Area2D.set_collision_mask_bit(1, false)
	
func _on_Area2D_area_entered(area):
	if player and player.has_method("gainHealth"):
		player.gainHealth(healAmount)
		queue_free()
