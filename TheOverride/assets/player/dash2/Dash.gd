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
	EventBus.emit_signal("spawnLoot", ghost) # TODO: think about using a generic child adding signal for cases like this
	
	ghost.global_position = global_position
	ghost.frames = sprite.frames
	ghost.animation = sprite.animation
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

