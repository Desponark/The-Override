extends RigidBody2D

var node = null

func _integrate_forces(state):
	rotation_degrees = 0	
	
func _physics_process(delta):
	if node != null:
		var tween = create_tween()
		tween.tween_property(self, "global_transform", node.getRobotFollowPosition(), 0.5)

func interact(area):
	if node == null:
		node = area.owner
	else:
		node = null
