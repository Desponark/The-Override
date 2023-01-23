extends KinematicBody2D

const upDirection = Vector2.UP
# movement vars
export var gravity = 4500.0
export var moveSpeed = 400.0
export (float, 0, 1.0) var acceleration = 0.1
var horizontalDirection = -1
var velocity = Vector2.ZERO

var knockBackForce = Vector2.ZERO


func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	EventBus.emit_signal("enemyWasHit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)

func knockBack(sourcePosition):
	# not currently functional
#	$HitParticles.rotation = get_angle_to(sourcePosition) + PI
#	knockBackForce = - global_position.direction_to(sourcePosition) * 300
	pass

func _physics_process(delta):
	# apply gravity
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, upDirection)

# if body enters range start ranged combat
func _on_DetectionArea_body_entered(body):
	$Gun.startShooting(body)

func _on_DetectionArea_body_exited(body):
	$Gun.stopShooting()

func _on_HealthBar_healthReachedZero():
	queue_free()
