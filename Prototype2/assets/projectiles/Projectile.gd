extends RigidBody2D

var maxSpeed
export var maxDistance = 25000.0
var distanceTravelled = 0.0

onready var startPosition = global_position

func setup(startVelocity):
	linear_velocity = startVelocity
	maxSpeed = startVelocity.length()
	
func _ready():
	fixRotation()
	
func _integrate_forces(state):
	state.linear_velocity = linear_velocity.normalized() * maxSpeed
	
#func _physics_process(delta):
#	distanceTravelled += global_position.distance_to(startPosition)
#	if distanceTravelled >= maxDistance:
#		queue_free()
	
func _process(delta):
	fixRotation()
	
func fixRotation():
	var rotation = Vector2.RIGHT.angle_to(linear_velocity)
	$Sprite.global_rotation = rotation

func takeDamage():
	print("takeDamage")
	pass

func _on_Projectile_body_entered(body):
	print("projectile entered body: ", body)
	queue_free()
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
