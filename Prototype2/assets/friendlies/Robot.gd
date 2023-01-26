extends RigidBody2D

var isFollowingPlayer = false
var player = null


func _integrate_forces(state):
	rotation_degrees = 0 # disable rotation... only useful if robot actually has collisions
	
# TODO: think about a better way to change light scale
func _process(delta):
	var lightScale = 3 * (getHealth() / getMaxHealth())
	if lightScale <= 0.4:
		lightScale = 0.4
	$Light2D.set_texture_scale(lightScale)
	
func _physics_process(delta):
	if player != null:
		if isFollowingPlayer:
			$AnimationPlayer.play("idle")
			setRobotTransform(player.getRobotFollowPosition())

func setRobotTransform(transform):
	var tween = create_tween()
	tween.tween_property(self, "global_transform", transform, 0.5)
	
func putRobotInSocket(transform):
	$AnimationPlayer.play("RESET")
	isFollowingPlayer = false
	setRobotTransform(transform)

func interact(area):
	if player == null:
		player = area.owner
		if player.has_method("setRobotRef"):
			player.setRobotRef(self)
			isFollowingPlayer = true
			# disable robot interaction collision shape so it can't be activated again
			$InteractionableBox/CollisionShape2D.disabled = true
#	else:
#		if player.has_method("setRobotRef"):
#			player.setRobotRef(null)
#			isFollowingPlayer = false
#			$InteractionableBox/CollisionShape2D.disabled = false
#			player = null

func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
		
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
func transferHealth(damage):
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
		
func getHealth():
	return $HealthBar.getHealth()
	
func getMaxHealth():
	return $HealthBar.getMaxHealth()

func getPriority():
	return 2
