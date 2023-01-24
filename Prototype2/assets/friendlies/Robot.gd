extends RigidBody2D

var isFollowingPlayer = false
var player = null

func _integrate_forces(state):
	rotation_degrees = 0 # disable rotation... only useful if robot actually has collisions
	
func _physics_process(delta):
	if player != null:
		if isFollowingPlayer:
			setRobotTransform(player.getRobotFollowPosition())

func setRobotTransform(transform):
	var tween = create_tween()
	tween.tween_property(self, "global_transform", transform, 0.5)

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

func getPriority():
	return 2
