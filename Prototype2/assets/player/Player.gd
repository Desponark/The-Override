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

enum MOTIONSTATE {FALLING, JUMPING, DOUBLEJUMPING, JUMPCANCELLED, IDLING, RUNNING, ASCENDING}
var motionState = MOTIONSTATE.IDLING

var canDash = false
var isDashButtonPressed = false
export var dashStrength = 2000.0
export var dashDuration = 0.2

var robotRef

var isTransferingHealth = false
export var healthTransferAmount = 1.0
# this multiplies the player health when charging the robot so the robot receives more (or less) health
export var healthTransferMultiplier = 2.0
# TODO: Improve and cleanup health transfer system
# Change where health is stored.
# Change how health transfer works.
# Change how robot and player are accessed.



func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		$AnimationPlayer.play("attack")
	
	if event.is_action_pressed("transferHealth"):
		isTransferingHealth = true
	if event.is_action_released("transferHealth"):
		isTransferingHealth = false
	
	if event.is_action_pressed("dash"):
		if $Dash.canDash and !$Dash.isDashing():
			isDashButtonPressed = true
			$Dash.startDash($Sprite, dashDuration, $HurtBox/CollisionShape2D)
		
func _process(_delta):
	transferHealth()
	
func _physics_process(delta: float):
	var horizontalDirection = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity = calculateMoveVelocity(horizontalDirection, delta)
	
	motionState = getPlayerMotionState()

	handleJumping()
	
	dash(horizontalDirection)
	
	playAnimations(horizontalDirection)
	
	velocity = move_and_slide(velocity, upDiretion)
	
	switchSpriteDirection(horizontalDirection)
	
func getPlayerMotionState():
	if Input.is_action_just_released("jump") and velocity.y < minJumpHeight:
		return MOTIONSTATE.JUMPCANCELLED
	elif Input.is_action_just_pressed("jump") and motionState == MOTIONSTATE.FALLING:
		return MOTIONSTATE.DOUBLEJUMPING
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		return MOTIONSTATE.JUMPING
	elif velocity.y > 0.0 and not is_on_floor():
		return MOTIONSTATE.FALLING
	elif velocity.y < 0.0 and not is_on_floor():
		return MOTIONSTATE.ASCENDING
	elif is_on_floor() and not (velocity.x < 1 and velocity.x > -1): #not is_zero_approx(velocity.x):
		return MOTIONSTATE.RUNNING
	elif is_on_floor() and (velocity.x < 1 and velocity.x > -1): #is_zero_approx(velocity.x):
		return MOTIONSTATE.IDLING
	else: # return IDLING as default state
		return MOTIONSTATE.IDLING
	
func dash(horizontalDirection):
	if isDashButtonPressed and horizontalDirection != 0:
		velocity.x = horizontalDirection * dashStrength
		isDashButtonPressed = false
	
func handleJumping():
	match motionState:
		MOTIONSTATE.JUMPING:
			jumpsMade += 1
			velocity.y = maxJumpHeight
		MOTIONSTATE.DOUBLEJUMPING:
			jumpsMade += 1
			if jumpsMade <= maximumJumps:
				velocity.y = doubleJumpHeight
		MOTIONSTATE.JUMPCANCELLED:
			velocity.y = minJumpHeight
		MOTIONSTATE.IDLING, MOTIONSTATE.RUNNING:
			jumpsMade = 0

func playAnimations(horizontalDirection):
	# if attack animation plays dont play any other animation
	if $AnimationPlayer.current_animation == "attack":
		return
	match motionState:
		MOTIONSTATE.JUMPING, MOTIONSTATE.DOUBLEJUMPING:
			$AnimationPlayer.play("jump")
		MOTIONSTATE.RUNNING:
			# slow down animation speed if the player is decelerating
			if horizontalDirection == 0 and velocity.x != 0:
				$AnimationPlayer.play("run", -1, 0.4)
			else:
				$AnimationPlayer.play("run")
		MOTIONSTATE.FALLING:
			$AnimationPlayer.play("fall")
		MOTIONSTATE.IDLING:
			$AnimationPlayer.play("idle")

func calculateMoveVelocity(horizontalDirection, delta):
	if horizontalDirection != 0:
		# speed up the player
		velocity.x = lerp(velocity.x, horizontalDirection * maxSpeed, acceleration)
		
		# Lars: use tween instead of lerp for example tween method -> tween_method(setVelocityX(value), ...)
	else:
		# slow down the player
		velocity.x = lerp(velocity.x, 0, friction)

	# aplly downwards gravity
	velocity.y += gravity * delta
	
	return velocity
	
func switchSpriteDirection(horizontalDirection):
	if horizontalDirection != 0:
		if horizontalDirection > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true

# TODO: implement heal function
func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
	
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
func transferHealth():
	if isTransferingHealth and robotRef != null:
		if $HealthBar.getHealth() <= healthTransferAmount: # if player has 1 health or less disallow transfering of health
			return
		if robotRef.getHealth() >= robotRef.getMaxHealth(): # if robot is full health disallow transfering of health
			return
		if $HealthBar.has_method("subtractHealth"):
			$HealthBar.subtractHealth(healthTransferAmount)
		robotRef.transferHealth(-(healthTransferAmount * healthTransferMultiplier))
	
func getRobotFollowPosition():
	return $RobotFollowPosition.global_transform
	
func setRobotRef(robot):
	robotRef = robot
	
func getRobotRef():
	return robotRef
	
# TODO: think about different solution
func getPriority():
	return 1
	
func _on_HealthBar_healthReachedZero(): # handle player death here
	var _ignore = get_tree().reload_current_scene()
