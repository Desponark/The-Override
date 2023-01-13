extends RigidBody2D

var speed

func setup(start_velocity):
	linear_velocity = start_velocity
	speed = start_velocity.length()
	pass

func _ready():
	fix_rotation()
	pass
	
func _integrate_forces(state):
	state.linear_velocity = linear_velocity.normalized() * speed
	pass
	
func _process(delta):
	fix_rotation()
	pass

func fix_rotation():
	var r = Vector2.RIGHT.angle_to(linear_velocity)
	$Sprite.global_rotation = r
	pass
	
func _on_Projectile_body_entered(body):
	if body.has_method("collided_with_projectile"):
		body.collided_with_projectile(self)
	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
