extends KinematicBody2D

const upDirection = Vector2.UP

export var gravity = 4500.0
export var moveSpeed = 200.0
export(int) var stopDistance = 200.0
var horizontalDirection = 0
var velocity = Vector2.ZERO

var approachTargets = []
var rangedTargets = []

export(PackedScene) var healthDrop


func _physics_process(delta):
	velocity.y += gravity * delta
	
	var approachTarget = getPriorityTarget(approachTargets)
	
	velocity = moveEnemyTowardsTarget(approachTarget)
	
	switchSpriteDirection(approachTarget)
	
	playAnimations()
	
	velocity = move_and_slide(velocity, upDirection)

func getPriorityTarget(array):
	if array.size() == 0:
		return null
	var prio = 0
	var index = 0
	for i in array.size():
		var element = array[i]
		if element.has_method("getPriority"):
			if prio < element.getPriority():
				prio = element.getPriority()
				index = i
	return array[index]

func moveEnemyTowardsTarget(approachTarget):
	if approachTarget != null:
		if abs(approachTarget.global_position.x - global_position.x) <= stopDistance:
			horizontalDirection = 0
		elif approachTarget.global_position.x > global_position.x:
			horizontalDirection = 1
		elif approachTarget.global_position.x < global_position.x:
			horizontalDirection = -1
		else:
			horizontalDirection = 0
			
	velocity.x = horizontalDirection * moveSpeed
	return velocity

func switchSpriteDirection(approachTarget):
	if horizontalDirection != 0:
		var facingRight = horizontalDirection < 0
		$AnimatedSprite.flip_h = facingRight
	elif approachTarget: # face in the diretion of the target if not otherwise moving in another direction
		var facingRight = approachTarget.global_position.x < global_position.x
		$AnimatedSprite.flip_h = facingRight

func playAnimations():
	if $AnimationPlayer.current_animation == "destroyed":
		return
	if $AnimationPlayer.current_animation == "shoot":
		velocity.x = 0.0 # stop moving while shooting
		return
	if is_zero_approx(velocity.x):
		$AnimationPlayer.stop(false)
	else:
		$AnimationPlayer.play("walk2")

func takeDamage(damage):
	$DamagedSound.play()
	$VFXAnimationPlayer.play("hit")
	EventBus.emit_signal("enemyWasHit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)

func setInitialMoveDirection(direction):
	horizontalDirection = direction

func _on_RangedAggroZone_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("robot"):
		rangedTargets.append(body)
	
	var target = getPriorityTarget(rangedTargets)
	if target != null:
		$Gun.startShooting(target)

func _on_RangedAggroZone_body_exited(body):
	var found = rangedTargets.find(body)
	if found != -1:
		rangedTargets.remove(found)
	
	if rangedTargets.size() <= 0:
		$Gun.stopShooting()

func _on_HealthBar_healthReachedZero():
	if healthDrop != null:
		var newHealthDrop = healthDrop.instance()
		newHealthDrop.global_position = global_position
		EventBus.emit_signal("spawnLoot", newHealthDrop)
	$AnimatedSprite.scale.x *= -1 # swap x direction because destroyed animation sprites have swapped directions
	$AnimationPlayer.play("destroyed")
	
func _on_AggroZone_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("robot"):
		approachTargets.append(body)

func _on_AggroZone_body_exited(body):
	var found = approachTargets.find(body)
	if found != -1:
		approachTargets.remove(found)

func _on_Gun_shooting():
	$AnimationPlayer.play("shoot")
