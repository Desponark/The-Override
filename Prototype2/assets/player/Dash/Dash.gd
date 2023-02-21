extends Node2D

var canDash = true
export(PackedScene) var dashGhostScene
var sprite
signal dashStart
signal dashEnd

func startDash(givenSprite, duration):
	self.sprite = givenSprite
	
	$DashDuration.wait_time = duration
	$DashDuration.start()
	
	$GhostDuration.start()
	instanceDashGhost()
	emit_signal("dashStart")
	
func instanceDashGhost():
	var ghost = dashGhostScene.instance()
	# TODO: change how child gets added
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.scale = sprite.scale
	ghost.scale *= 2 # TODO: Fix this properly

# tells us if the timer is currently running -> therefore dashing
func isDashing():
	return !$DashDuration.is_stopped()

func endDash():
	$GhostDuration.stop()
	canDash = false
	$DashCooldown.start()
	emit_signal("dashEnd")
	
func _on_DashCooldown_timeout():
	canDash = true

func _on_DashDuration_timeout():
	endDash()

func _on_GhostDuration_timeout():
	instanceDashGhost()

