extends KinematicBody2D

var isFollowingPlayer = false
var player = null
export var followSpeedMultiplier = 3
export var lightScaleMultiplier = 0.5
export var minimumLightScaleMultiplier = 0.3

func _ready():
	$CanvasLayer/HealthBar.hide()

# TODO: think about a better way to change light scale
func _process(_delta):
	changeLightScale()
	
func _physics_process(_delta):
	if player != null:
		if isFollowingPlayer:
			$AnimationPlayer.play("idle")
			move_and_slide((player.getRobotFollowPosition() - global_position) * followSpeedMultiplier)

func changeLightScale():
	var lightScale = lightScaleMultiplier * (getHealth() / getMaxHealth())
	# stop lightscale from getting too small
	if lightScale <= minimumLightScaleMultiplier:
		lightScale = minimumLightScaleMultiplier
	$Light2D.set_texture_scale(lightScale)
	
func putRobotInSocket(position):
	$AnimationPlayer.play("RESET")
	isFollowingPlayer = false
	var tween = create_tween()
	tween.tween_property(self, "global_position", position, 0.5)

func takeDamage(damage):
	$VFXAnimationPlayer.play("hit")
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)
		$DamagedSound.play()
		
# TODO: implement properly. temporarily added this in order to not trigger hit vfx when transfering health
func transferHealth(damage):
	if $CanvasLayer/HealthBar.has_method("subtractHealth"):
		$CanvasLayer/HealthBar.subtractHealth(damage)
		
func getHealth():
	return $CanvasLayer/HealthBar.getHealth()
	
func getMaxHealth():
	return $CanvasLayer/HealthBar.getMaxHealth()

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
	EventBus.emit_signal("loseEvent", "Your Robot died!")

func _on_InteractionableBox_interacted(area):
	if player == null:
		player = area.owner
		if player.has_method("setRobotRef"):
			player.setRobotRef(self)
			isFollowingPlayer = true
			$CanvasLayer/HealthBar.show()
			# disable robot interaction collision shape so it can't be activated again
			$InteractionableBox/CollisionShape2D.disabled = true

# TODO: implement properly
func playSocketStoppedCharging():
	if !$SocketStoppedCharging.playing:
		$SocketStoppedCharging.play()
