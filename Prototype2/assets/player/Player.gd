extends KinematicBody2D

const upDirection = Vector2.UP

export var maxSpeed = 600.0
export var maxJumpHeight = -1500.0
export var minJumpHeight = -500.0
export var maximumDoubleJumps = 0
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

var robot

var isTransferingHealth = false
export var healthTransferAmount = 1.0
export var healthTransferMultiplier = 2.0 # this multiplies the player health when charging the robot so the robot receives more (or less) health
# TODO: Improve and cleanup health transfer system
# Change where health is stored.
# Change how robot and player are accessed.

# TODO: implement properly when there is time
var isDashUnlocked = false
var isProjectileReflectUnlocked = false

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
#		$AnimationPlayer.play("attack")
		$AnimationPlayer2.play("attack")
	
	if event.is_action_pressed("transferHealth"):
		isTransferingHealth = true
	if event.is_action_released("transferHealth"):
		isTransferingHealth = false
	
	if event.is_action_pressed("dash") and isDashUnlocked:
		if $Dash.canDash and !$Dash.isDashing():
			$DodgeSound.play()
			$Dash.startDash($AnimatedSprite, dashDuration)
		
func _process(_delta):
	transferHealth()
	
	if robot: #shows right mouse button if robot is low health
		var healthPercent = robot.getHealth() / robot.getMaxHealth()
		$RightMouseButton.visible = healthPercent <= .25
		
	$HealthAbsorbtionArea.global_position = getHealthBarPosition()
	
func _physics_process(delta: float):
	var horizontalDirection = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	velocity = calculateMoveVelocity(horizontalDirection, delta)
	
	var previousMotionState = motionState
	
	motionState = getPlayerMotionState()

	if motionState == MOTIONSTATE.FALLING and (previousMotionState == MOTIONSTATE.RUNNING or previousMotionState == MOTIONSTATE.IDLING):
		$CoyoteTimer.start()

	handleJumping()

	dash(horizontalDirection)

	fallThroughPlatform()
	
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

func dash(horizontalDirection):
	if $Dash.isDashing():
		velocity.x = horizontalDirection * dashStrength

func fallThroughPlatform():
	if motionState == MOTIONSTATE.JUMPING and Input.is_action_pressed("down"):
		velocity.y = 0
		set_collision_layer_bit(9, false)
		set_collision_mask_bit(9, false)
		$FallThroughPlatformTimer.start()

func playAnimations(horizontalDirection):
	if $AnimationPlayer2.current_animation == "attack":
		return
#	if $AnimationPlayer.current_animation == "attack": # if attack animation plays dont play any other animation
#		return
	match motionState:
		MOTIONSTATE.JUMPING, MOTIONSTATE.DOUBLEJUMPING:
			$JumpSound.play()
			$AnimationPlayer.play("jump")
			$AnimationPlayer2.play("jump")
		MOTIONSTATE.RUNNING:
			if horizontalDirection == 0 and velocity.x != 0: # slow down animation speed if the player is decelerating
				$AnimationPlayer.play("run", -1, 0.4)
				$AnimationPlayer2.play("run", -1, 0.4)
			else:
				$AnimationPlayer.play("run")
				$AnimationPlayer2.play("run")
		MOTIONSTATE.FALLING:
			$AnimationPlayer.play("fall")
			$AnimationPlayer2.play("fall")
		MOTIONSTATE.IDLING:
			$AnimationPlayer.play("idle")
			$AnimationPlayer2.play("idle")

func switchSpriteDirection(horizontalDirection):
	if horizontalDirection != 0:
		$Sprite.scale.x = abs($Sprite.scale.x) * -1.0 if horizontalDirection < 0 else abs($Sprite.scale.x)
		$AnimatedSprite.scale.x = abs($AnimatedSprite.scale.x) * -1.0 if horizontalDirection < 0 else abs($AnimatedSprite.scale.x)

# TODO: implement heal function
func takeDamage(damage):
	$DamagedSound.play()
	$VFXAnimationPlayer.play("hit")
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)
		$CanvasLayer/HealthBar/AnimationPlayer.play("healthLose")

func gainHealth(healAmount):
	$CanvasLayer/HealthBar/AnimationPlayer.play("healthGain")
	if $CanvasLayer/HealthBar.has_method("addHealth"):
		$CanvasLayer/HealthBar.addHealth(healAmount)
		$VFXAnimationPlayer.play("healthGain")
		
func getHealthBarPosition():
	# TODO: look at this
	# https://stackoverflow.com/questions/73038798/is-there-an-easier-way-to-turn-canvas-locations-into-node2d-locations
	# turns a different canvas position into the main canvas position
	return get_viewport_transform().affine_inverse() * $CanvasLayer/Position2D.global_position
	
func transferHealth():
	if isTransferingHealth and robot:
		if $CanvasLayer/HealthBar.getHealth() <= healthTransferAmount: # if player has 1 health or less disallow transfering of health
			return
			
		var missingHealth = robot.getMaxHealth() - robot.getHealth()
		var incomingHealth = healthTransferAmount * healthTransferMultiplier
		
		if (missingHealth) < incomingHealth: # only allow health transfer if the robot has enough missing health to fit the health that is going to be transferred
			return
			
		if $CanvasLayer/HealthBar.has_method("subtractHealth"):
			$CanvasLayer/HealthBar.subtractHealth(healthTransferAmount)
			$CanvasLayer/HealthBar/AnimationPlayer.play("transferHealth")
		robot.gainHealth((incomingHealth))
	
func getRobotFollowPosition():
	return $RobotFollowPosition.global_position
	
func setRobotRef(robotValue):
	robot = robotValue
	
func getRobotRef():
	return robot
	
# TODO: think about different solution
func getPriority():
	return 3
	
func _on_HealthBar_healthReachedZero():
	EventBus.emit_signal("loseEvent", "You Died!")
	
# TODO: make this implementation proper when there is time
func unlockAbility(ability, videoStream, headline, button, explainationText):
	if ability == "dash":
		isDashUnlocked = true
	elif ability == "reflect":
		isProjectileReflectUnlocked = true
		$ProjectileHitBox.set_collision_mask_bit(12, true)
	EventBus.emit_signal("playerAbilityUnlocked", videoStream, headline, button, explainationText)

func _on_Dash_dashStart():
	set_collision_mask_bit(0, false) # world collisions
	set_collision_mask_bit(9, false) # platform collisions
	$HurtBox/CollisionShape2D.disabled = true

func _on_Dash_dashEnd():
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(9, true)
	$HurtBox/CollisionShape2D.disabled = false

func _on_FallThroughPlatformTimer_timeout():
	set_collision_layer_bit(9, true)
	set_collision_mask_bit(9, true)
	
func saveData():
	return {
		"nodePath" : get_path(),
		"posX" : position.x,
		"posY" : position.y,
		"health" : $CanvasLayer/HealthBar.getHealth(),
		"isDashUnlocked" : isDashUnlocked,
		"isProjectileReflectUnlocked" : isProjectileReflectUnlocked,
		"robotPath" : robot.get_path() if robot else ""
	}
	
func loadData(data):
	print(data)
	position.x = data["posX"]
	position.y = data["posY"]
	$CanvasLayer/HealthBar.health = data["health"]
	isDashUnlocked = data["isDashUnlocked"]
	isProjectileReflectUnlocked = data["isProjectileReflectUnlocked"]
	if isProjectileReflectUnlocked:
		$ProjectileHitBox.set_collision_mask_bit(12, true)
	robot = get_node_or_null(data["robotPath"])
