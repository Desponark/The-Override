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

export var maxHealth = 100
var health = 100

func _ready():
	health = maxHealth
	
func _physics_process(delta: float):
	var horizontalDirection = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	velocity = calculateMoveVelocity(horizontalDirection, delta)
	
	var isFalling = velocity.y > 0.0 and not is_on_floor()
	var isJumping = Input.is_action_just_pressed("jump") and is_on_floor()
	var isDoubleJumping = Input.is_action_just_pressed("jump") and isFalling
	var isJumpCancelled = Input.is_action_just_released("jump") and velocity.y < minJumpHeight
	var isIdling = is_on_floor() and is_zero_approx(velocity.x)
	var isRunning = is_on_floor() and not is_zero_approx(velocity.x)
	
	# handle jumping
	if isJumping:
		jumpsMade += 1
		velocity.y = maxJumpHeight
	elif isDoubleJumping:
		jumpsMade += 1
		if jumpsMade <= maximumJumps:
			velocity.y = doubleJumpHeight
	elif isJumpCancelled:
		velocity.y = minJumpHeight
	elif isIdling or isRunning:
		jumpsMade = 0
	
	# play animations	
	if isJumping or isDoubleJumping:
		$AnimationPlayer.play("Jump")
	elif isRunning:
		$AnimationPlayer.play("Run")
	elif isFalling:
#		$AnimationPlayer.play("Fall")
		pass
	elif isIdling:
		$AnimationPlayer.play("Idle")
	
	velocity = move_and_slide(velocity, upDiretion)
	
	switchSpriteDirection(horizontalDirection)
	
func calculateMoveVelocity(horizontalDirection, delta):
	if horizontalDirection != 0:
		# speed up the player
		velocity.x = lerp(velocity.x, horizontalDirection * maxSpeed, acceleration)
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
