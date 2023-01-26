extends KinematicBody2D

const upDiretion = Vector2.UP

export var maxSpeed = 600.0
export var maxJumpHeight = -1500.0
export var minJumpHeight = -500.0
export var maximumJumps = 2
export var doubleJumpHeight = -1200.0
export var gravity = 4500.0
export (float, 0, 1.0) var acceleration = 0.1
export (float, 0, 1.0) var friction = 0.2

var jumpsMade = 0
var velocity = Vector2.ZERO

enum MOTIONSTATE {falling, jumping, doubleJumping, jumpCancelled, idling, running, ascending}
var motionState = MOTIONSTATE.idling

var robotRef

var isTransferingHealth = false
export var healthTransferAmount = 1.0
# TODO: Improve and cleanup health transfer system
# Change where health is stored.
# Change how health transfer works.
# Change how robot and player are accessed



func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		$AnimationPlayer.play("attack")
	# health transfer
	if event.is_action_pressed("transferHealth"):
		isTransferingHealth = true
	if event.is_action_released("transferHealth"):
		isTransferingHealth = false
		
func _process(delta):
	if isTransferingHealth and robotRef != null:
		# if player has 1 health or less disallow transfering of health
		if $HealthBar.getHealth() <= healthTransferAmount:
			return
		# if robot is full health disallow transfering of health
		if robotRef.getHealth() >= robotRef.getMaxHealth():
			return
		# remove health from player
#		takeDamage(healthTransferAmount)
		transferHealth(healthTransferAmount)
		# add health to robot
#		robotRef.takeDamage(-(healthTransferAmount * 2))
		robotRef.transferHealth(-(healthTransferAmount * 2))
	
func _physics_process(delta: float):
	var horizontalDirection = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity = calculateMoveVelocity(horizontalDirection, delta)
	
	motionState = getPlayerMotionState()

	handleJumping()
	
	playAnimations(horizontalDirection)
	
	velocity = move_and_slide(velocity, upDiretion)
	
	switchSpriteDirection(horizontalDirection)
	
func getPlayerMotionState():
	if Input.is_action_just_released("jump") and velocity.y < minJumpHeight:
		return MOTIONSTATE.jumpCancelled
	elif Input.is_action_just_pressed("jump") and motionState == MOTIONSTATE.falling:
		return MOTIONSTATE.doubleJumping
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		return MOTIONSTATE.jumping
	elif velocity.y > 0.0 and not is_on_floor():
		return MOTIONSTATE.falling
	elif velocity.y < 0.0 and not is_on_floor():
		return MOTIONSTATE.ascending
	elif is_on_floor() and not (velocity.x < 1 and velocity.x > -1): #not is_zero_approx(velocity.x):
		return MOTIONSTATE.running
	elif is_on_floor() and (velocity.x < 1 and velocity.x > -1): #is_zero_approx(velocity.x):
		return MOTIONSTATE.idling
	else: # return idling as default state
		return MOTIONSTATE.idling
	
func handleJumping():
	match motionState:
		MOTIONSTATE.jumping:
			jumpsMade += 1
			velocity.y = maxJumpHeight
		MOTIONSTATE.doubleJumping:
			jumpsMade += 1
			if jumpsMade <= maximumJumps:
				velocity.y = doubleJumpHeight
		MOTIONSTATE.jumpCancelled:
			velocity.y = minJumpHeight
		MOTIONSTATE.idling, MOTIONSTATE.running:
			jumpsMade = 0

func playAnimations(horizontalDirection):
	# if attack animation plays dont play any other animation
	if $AnimationPlayer.current_animation == "attack":
		return
	match motionState:
		MOTIONSTATE.jumping, MOTIONSTATE.doubleJumping:
			$AnimationPlayer.play("jump")
		MOTIONSTATE.running:
			# slow down animation speed if the player is decelerating
			if horizontalDirection == 0 and velocity.x != 0:
				$AnimationPlayer.play("run", -1, 0.4)
			else:
				$AnimationPlayer.play("run")
		MOTIONSTATE.falling:
			$AnimationPlayer.play("fall")
		MOTIONSTATE.idling:
			$AnimationPlayer.play("idle")

func calculateMoveVelocity(horizontalDirection, delta):
	if horizontalDirection != 0:
		# speed up the player
		velocity.x = lerp(velocity.x, horizontalDirection * maxSpeed, acceleration)
		
		# Lars: use tween instead of lerp
		# experimental tween approach
		# problem: using this approach works but spams an unknown error
#		var tween = create_tween()
#		velocity.x = tween.interpolate_value(velocity.x, (horizontalDirection * maxSpeed) - velocity.x, 0.1, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	else:
		# slow down the player
		velocity.x = lerp(velocity.x, 0, friction)
		
		# experimental tween approach
#		var tween = create_tween()
#		velocity.x = tween.interpolate_value(velocity.x, 0.0 - velocity.x, 0.2, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	# aplly downwards gravity
	velocity.y += gravity * delta
	
	return velocity
	
func switchSpriteDirection(horizontalDirection):
	if horizontalDirection != 0:
		if horizontalDirection > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true

func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
	
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
func transferHealth(damage):
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
	
func getRobotFollowPosition():
	return $RobotFollowPosition.global_transform
	
func setRobotRef(robot):
	robotRef = robot
	
func getRobotRef():
	return robotRef
	
	# TODO: think about different solution
func getPriority():
	return 1
	
func _on_HealthBar_healthReachedZero():
	# handle player death here
	get_tree().reload_current_scene()
