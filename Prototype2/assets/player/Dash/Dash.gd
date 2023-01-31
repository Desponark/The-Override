extends Node2D

var canDash = true
var dashGhostScene = preload("res://assets/player/Dash/DashGhost.tscn")
var sprite
var hurtBoxCollisionShape

func startDash(givenSprite, duration, givenCollisionShape):
	self.sprite = givenSprite
	self.hurtBoxCollisionShape = givenCollisionShape
	self.hurtBoxCollisionShape.disabled = true
	
	$DashDuration.wait_time = duration
	$DashDuration.start()
	
	$GhostDuration.start()
	instanceDashGhost()
	
func instanceDashGhost():
	var ghost = dashGhostScene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.scale = sprite.scale

# tells us if the timer is currently running -> therefore dashing
func isDashing():
	return !$DashDuration.is_stopped()

func endDash():
	$GhostDuration.stop()
	canDash = false
	hurtBoxCollisionShape.disabled = false
	$DashCooldown.start()
	
func _on_DashCooldown_timeout():
	canDash = true

func _on_DashDuration_timeout():
	endDash()

func _on_GhostDuration_timeout():
	instanceDashGhost()

