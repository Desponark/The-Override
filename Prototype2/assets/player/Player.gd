extends KinematicBody2D

const upDirection = Vector2.UP

export var maxSpeed = 600.0
export var maxJumpHeight = -1500.0
export var minJumpHeight = -500.0
export var maximumDoubleJumps = 1
export var doubleJumpHeight = -1200.0
export var gravity = 4500.0
export (float, 0, 1.0) var acceleration = 0.1
export (float, 0, 1.0) var friction = 0.1

var doubleJumpsMade = 0
var velocity = Vector2.ZERO

enum MOTIONSTATE {FALLING, JUMPING, DOUBLEJUMPING, JUMPCANCELLED, IDLING, RUNNING, ASCENDING}
var motionState = MOTIONSTATE.IDLING

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
			$DodgeSound.play()
			$Dash.startDash($Sprite, dashDuration)
		
func _process(_delta):
	transferHealth()
	$HealthAbsorbtionArea.global_position = getHealthBarPosition()
	
func _physics_process(delta: float):
	var horizontalDirection = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity = calculateMoveVelocity(horizontalDirection, delta)
	
	var previousMotionState = motionState
	
	motionState = getPlayerMotionState()
#	print(MOTIONSTATE.keys()[motionState])

	if motionState == MOTIONSTATE.FALLING and (previousMotionState == MOTIONSTATE.RUNNING or previousMotionState == MOTIONSTATE.IDLING):
		$CoyoteTimer.start()

	handleJumping()
	
	dash(horizontalDirection)
	
	playAnimations(horizontalDirection)
	
	velocity = move_and_slide(velocity, upDirection, true)
	
	switchSpriteDirection(horizontalDirection)
	
func calculateMoveVelocity(horizontalDirection, delta):
	# TODO: look at this
	var speedGoal = 0.0
	var duration = friction
	if horizontalDirection != 0:
		speedGoal = horizontalDirection * maxSpeed
		duration = acceleration
	
	# TODO: change implementation because creating a new tween every frame is wasteful
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_method(self, "tweenVelocityX", velocity.x, speedGoal, duration)
	
	velocity.y += gravity * delta # apply downwards gravity
	return velocity
	
func tweenVelocityX(tweenedVelocity):
	velocity.x = tweenedVelocity
	
func getPlayerMotionState():
	if Input.is_action_just_released("jump") and velocity.y < minJumpHeight:
		return MOTIONSTATE.JUMPCANCELLED
	elif Input.is_action_just_pressed("jump") and (is_on_floor() or !$CoyoteTimer.is_stopped()):
		return MOTIONSTATE.JUMPING
	elif Input.is_action_just_pressed("jump") and motionState == MOTIONSTATE.FALLING and doubleJumpsMade < maximumDoubleJumps:
		return MOTIONSTATE.DOUBLEJUMPING
	elif velocity.y > 0.0 and not is_on_floor():
		return MOTIONSTATE.FALLING
	elif velocity.y < 0.0 and not is_on_floor():
		return MOTIONSTATE.ASCENDING
	elif is_on_floor() and not (velocity.x < 1 and velocity.x > -1):
		return MOTIONSTATE.RUNNING
	elif is_on_floor() and (velocity.x < 1 and velocity.x > -1):
		return MOTIONSTATE.IDLING
	else:
		return MOTIONSTATE.IDLING
	
func dash(horizontalDirection):
	if $Dash.isDashing():
		velocity.x = horizontalDirection * dashStrength
		collision_mask = 0
		$HurtBox/CollisionShape2D.disabled = true
	else:
		collision_mask = 1
		$HurtBox/CollisionShape2D.disabled = false
	
func handleJumping():
	match motionState:
		MOTIONSTATE.JUMPING:
			velocity.y = maxJumpHeight
		MOTIONSTATE.DOUBLEJUMPING:
			doubleJumpsMade += 1
			velocity.y = doubleJumpHeight
		MOTIONSTATE.JUMPCANCELLED:
			velocity.y = minJumpHeight
		MOTIONSTATE.IDLING, MOTIONSTATE.RUNNING:
			doubleJumpsMade = 0
			$CoyoteTimer.stop() # stop coyote timer just to be sure

func playAnimations(horizontalDirection):
	if $AnimationPlayer.current_animation == "attack": # if attack animation plays dont play any other animation
		return
	match motionState:
		MOTIONSTATE.JUMPING, MOTIONSTATE.DOUBLEJUMPING:
			$JumpSound.play()
			$AnimationPlayer.play("jump")
		MOTIONSTATE.RUNNING:
			if horizontalDirection == 0 and velocity.x != 0: # slow down animation speed if the player is decelerating
				$AnimationPlayer.play("run", -1, 0.4)
			else:
				$AnimationPlayer.play("run")
		MOTIONSTATE.FALLING:
			$AnimationPlayer.play("fall")
		MOTIONSTATE.IDLING:
			$AnimationPlayer.play("idle")

func switchSpriteDirection(horizontalDirection):
	if horizontalDirection != 0:
		$Sprite.flip_h = horizontalDirection < 0

# TODO: implement heal function
func takeDamage(damage):
	$DamagedSound.play()
	$VFXAnimationPlayer.play("hit")
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)

func gainHealth(healAmount):
	if $CanvasLayer/HealthBar.has_method("addHealth"):
		$CanvasLayer/HealthBar.addHealth(healAmount)
		
func getHealthBarPosition():
	# TODO: look at this
	# https://stackoverflow.com/questions/73038798/is-there-an-easier-way-to-turn-canvas-locations-into-node2d-locations
	# turns a different canvas position into the main canvas position
	return get_viewport_transform().affine_inverse() * $CanvasLayer/Position2D.global_position
	
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
# TODO: make it so that the player can only give the robot life if the robot has enough missing health
func transferHealth():
	if isTransferingHealth and robotRef != null:
		if $CanvasLayer/HealthBar.getHealth() <= healthTransferAmount: # if player has 1 health or less disallow transfering of health
			return
		if robotRef.getHealth() >= robotRef.getMaxHealth(): # if robot is full health disallow transfering of health
			return
		if $CanvasLayer/HealthBar.has_method("subtractHealth"):
			$CanvasLayer/HealthBar.subtractHealth(healthTransferAmount)
		robotRef.transferHealth(-(healthTransferAmount * healthTransferMultiplier))
	
func getRobotFollowPosition():
	return $RobotFollowPosition.global_position
	
func setRobotRef(robot):
	robotRef = robot
	
func getRobotRef():
	return robotRef
	
# TODO: think about different solution
func getPriority():
	return 1
	
func _on_HealthBar_healthReachedZero(): # handle player death here
	#var _ignore = get_tree().reload_current_scene()
	get_node("/root/Game").free()
	get_tree().change_scene("res://assets/ui/EndGameScreen/PlayerLoseScreen.tscn")
	
func showPopUp(videoStream, headline, button, explainationText):
	$CanvasLayer/AbilityPopUp.show()
	$CanvasLayer/AbilityPopUp.setup(videoStream, headline, button, explainationText)
	$CanvasLayer/AbilityPopUp.start()
