extends KinematicBody2D
#extends RigidBody2D

const upDiretion = Vector2.UP

export var gravity = 4500.0
export var moveSpeed = 400.0
export (float, 0, 1.0) var acceleration = 0.1
var horizontalDirection = -1

var knockBackForce = Vector2.ZERO

var velocity = Vector2.ZERO


func takeDamage(damage):
	$AnimationPlayer.play("hit")
	EventBus.emit_signal("enemyWasHit")
	print(damage)


func knockBack(sourcePosition):
	$HitParticles.rotation = get_angle_to(sourcePosition) + PI
	knockBackForce = - global_position.direction_to(sourcePosition) * 300
#	velocity = knockBackForce
	
	print(knockBackForce)

func _physics_process(delta):
	# get knockbacked
#	knockBackForce = lerp(knockBackForce, Vector2.ZERO, delta * 10)
#	move_and_slide(knockBackForce, upDiretion)
	
	# apply gravity	
	velocity.y += gravity * delta
#	velocity.x += -moveSpeed * delta
#	clamp(velocity.x, 0.0, moveSpeed)
#	velocity.x = lerp(velocity.x, horizontalDirection * moveSpeed, acceleration)
	move_and_slide(velocity, upDiretion)

