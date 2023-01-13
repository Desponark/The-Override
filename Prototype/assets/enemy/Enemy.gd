extends KinematicBody2D

export (PackedScene) var crystal

export var speed = 100
var crystalPosition = Vector2(494,527)

export var maxHealth = 100
export var health = 100

export var gravity = 4000

func setup(pos):
	crystalPosition = pos

func _process(delta):
	if health <= 0:
		queue_free()
	pass

func _physics_process(delta):
	var motion = Vector2.ZERO
	var direction = 0
	if crystalPosition.x > global_position.x:
		direction = 1
	else:
		direction = -1
		
	switchCharDirection(direction)
	
	motion.x = speed * direction
	motion.y += gravity * delta
	move_and_slide(motion, Vector2.UP)

func switchCharDirection(direction):
	# switch directiona
	if direction > 0:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
		
func collided_with_projectile(projectile):
	health -= 50
	projectile.queue_free()
	pass
