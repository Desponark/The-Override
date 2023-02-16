extends RigidBody2D

var isFollowingPlayer = false
var player = null

# TODO: think about changing enemy from rigid body to node2d or sprite if physics are not needed for it

func _integrate_forces(_state):
	rotation_degrees = 0 # disable rotation... only useful if robot actually has collisions
	
# TODO: think about a better way to change light scale
func _process(_delta):
	changeLightScale()
	
func _physics_process(_delta):
	if player != null:
		if isFollowingPlayer:
			$AnimationPlayer.play("idle")
			setRobotTransform(player.getRobotFollowPosition())

func changeLightScale():
	var lightScale = 2 * (getHealth() / getMaxHealth())
	# stop lightscale from getting too small
	if lightScale <= 0.4:
		lightScale = 0.4
	$Light2D.set_texture_scale(lightScale)

func setRobotTransform(position):
	# TODO: recreating a new tween every frame seems bad? Creates slight stutter in some cases...
	var tween = create_tween()
	tween.tween_property(self, "global_position", position, 0.5)
	
func putRobotInSocket(position):
	$AnimationPlayer.play("RESET")
	isFollowingPlayer = false
	setRobotTransform(position)

func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $HealthBar.has_method("subtractHealth"):
		$HealthBar.subtractHealth(damage)
		$DamagedSound.play()
		
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
	
func playSpeech(dialougeStream, dialogueText, delay):
	if !dialougeStream:
		return
	
	$VoicePlayer.stream = dialougeStream
	$VoicePlayer.play()
	
	$SpeechBubble.setup(dialogueText, dialougeStream.get_length())
	$SpeechBubble.start()

func _on_HealthBar_healthReachedZero():
	#var _ignore = get_tree().reload_current_scene()
	get_tree().change_scene("res://assets/ui/EndGameScreen/RobotLoseScreen.tscn")

func _on_InteractionableBox_interacted(area):
	if player == null:
		player = area.owner
		if player.has_method("setRobotRef"):
			player.setRobotRef(self)
			isFollowingPlayer = true
			# disable robot interaction collision shape so it can't be activated again
			$InteractionableBox/CollisionShape2D.disabled = true
