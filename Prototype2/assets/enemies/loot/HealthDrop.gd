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
	# disable world collisions
	collision_layer = 0
	collision_mask = 0
	# disable player collisions
	$Area2D.set_collision_mask_bit(1, false)
	
func _on_Area2D_area_entered(area):
	if player and player.has_method("gainHealth"):
		player.gainHealth(healAmount)
		queue_free()
