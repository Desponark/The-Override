extends KinematicBody


export var moveSpeed = 5
export var jumpForce = 8
export var gravity = 9.8
export var maxFallSpeed = 30
var y_velo = 0
var facing_right = false


func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("ui_right"):
		move_dir += 1
	if Input.is_action_pressed("ui_left"):
		move_dir -= 1
		
	move_and_slide(Vector3(move_dir * moveSpeed, y_velo, 0), Vector3.UP)
	
	var just_jumped = false
	var grounded = is_on_floor()
	y_velo -= gravity * delta
	if y_velo < - maxFallSpeed:
		y_velo = - maxFallSpeed
	
	if grounded:
		y_velo = - 0.1
		if Input.is_action_pressed("jump"):
			y_velo = jumpForce
			just_jumped = true
			
	if move_dir < 0 and facing_right:
		flip()
	if move_dir > 0 and !facing_right:
		flip()
	pass

func flip():
	$MeshInstance.rotation_degrees.y *= -1
	facing_right = !facing_right
