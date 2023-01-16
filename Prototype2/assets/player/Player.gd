extends KinematicBody2D


export var maxSpeed = 500
export var maxJumpHeight = -500
export var minJumpHeight = -200
export var gravity = 1000
export (float, 0, 1.0) var friction = 0.2
export (float, 0, 1.0) var acceleration = 0.1

var velocity = Vector2.ZERO

export var maxHealth = 100
var health = 100


func _ready():
	health = maxHealth
	pass

func _process(delta):
	pass
	
func _physics_process(delta):
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if direction != 0:
		# speed up the player
		velocity.x = lerp(velocity.x, direction * maxSpeed, acceleration)
		switchSpriteDirection(direction)
	else:
		# slow down the player
		velocity.x = lerp(velocity.x, 0, friction)
		
	# aplly downwards gravity
	velocity.y += gravity * delta
	
	move_and_slide(velocity, Vector2.UP)
	
	jump()
	
	
func jump():
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = maxJumpHeight
		pass
	elif Input.is_action_just_released("jump") && velocity.y < minJumpHeight:
		velocity.y = minJumpHeight
		pass
	
	
func switchSpriteDirection(direction):
	# switch direction
	if direction > 0:
		$Sprite.scale.x = 2
	else:
		$Sprite.scale.x = -2
