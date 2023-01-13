extends KinematicBody2D


export var moveSpeed = 500
export var jump_speed = -500
export var gravity = 1000

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

export var maxHealth = 100
var health = 100
var healthChargeAmount = 1
var healthKillRestore = 50

var motion = Vector2.ZERO

export(NodePath) var crystalPath = null
var isCrystalInChargeRange = false
var crystal
var isCrystalFollowing = false

func setup(projectileParent):
	$DefaultGun.projectileParent = projectileParent

func _ready():
	health = maxHealth
#	crystal = get_parent().get_node("Crystal")
	if crystalPath != null:
		crystal = get_node(crystalPath)
	
func _process(delta):
	# clamp health to max
	if health > maxHealth:
		health = maxHealth
	
	if isCrystalInChargeRange == true:
		if Input.is_action_pressed("charge_crystal"):
			# charge the crystal
			health = health - healthChargeAmount
			crystal.health = crystal.health + healthChargeAmount
			print(health)
			print(crystal.health)
			pass
			
		# "carry" the "crystal"
		if Input.is_action_just_pressed("interact"):
			if !isCrystalFollowing:
				isCrystalFollowing = true
	# update healthbar
	updateHealthBar()
	
	shoot()
	attack()
	
	if isCrystalFollowing: 
		crystal.global_transform = $Position2D.global_transform.interpolate_with(crystal.global_transform, 0.9)
	
func _physics_process(delta):
	# x motion
	var direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if direction != 0:
		motion.x = lerp(motion.x, direction * moveSpeed, acceleration)
		switchCharDirection(direction)
		$AnimationPlayer.play("run")
	else:
		motion.x = lerp(motion.x, 0, friction)
		if $AnimationPlayer.get_current_animation() != "attack":
			$AnimationPlayer.play("idle")

	
	# y motion
	motion.y += gravity * delta
	
	# move character
	motion = move_and_slide(motion, Vector2.UP)
	
	# jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			$AnimationPlayer.play("jump")
			motion.y = jump_speed
#		else:
#			$AnimationPlayer.play("fall")

func updateHealthBar():
	$HealthBar/Health.max_value = maxHealth
	$HealthBar/Health.value = health

func switchCharDirection(direction):
	# switch direction
	if direction > 0:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1

func shoot():
	if Input.is_action_just_pressed("shoot"):
		$DefaultGun.shoot()
	pass

func attack():
	if Input.is_action_just_pressed("attack"):
		$AnimationPlayer.play("attack")
		# attack in direction that player is looking currently
		var enemies = $Sprite/HurtBox.get_overlapping_areas()
		print (enemies)
		if enemies.size() > 0:
			# get first enemy hit
			var enemy = enemies[0].get_parent()
			# hit the enemy
			enemy.health -= 100
			health += healthKillRestore

	
func animationAttack():
	print("attack done")
	$AnimationPlayer.play("idle")
	pass


func _on_ChargeArea_area_entered(area):
	# enable crystal charging
	print("entered")
	isCrystalInChargeRange = true
	pass # Replace with function body.


func _on_ChargeArea_area_exited(area):
	# disable crystal charging
	print("exited")
	isCrystalInChargeRange = false
	pass # Replace with function body.
