extends RigidBody2D

var maxSpeed

onready var startPosition = global_position

func setup(startVelocity):
	linear_velocity = startVelocity
	maxSpeed = startVelocity.length()
	
func _ready():
	fixRotation()
	
func _integrate_forces(state):
	state.linear_velocity = linear_velocity.normalized() * maxSpeed
	
func _process(_delta):
	fixRotation()
	
func fixRotation():
	var rotation = Vector2.RIGHT.angle_to(linear_velocity)
	$Sprite.global_rotation = rotation

func takeDamage(damage):
	# change projectile direction
	linear_velocity = linear_velocity * -1
	# change projectile collisions so it can hit enemies too
	$HitBox.collision_layer = 4
	collision_layer = 4
	# change damage
	$HitBox.damage = damage

func _on_Projectile_body_entered(_body):
	queue_free()

func _on_Timer_timeout():
	queue_free()
