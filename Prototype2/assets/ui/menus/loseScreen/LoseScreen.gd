extends Control

var player = null

func _ready():
	visible = false

func setup(text, playerRef):
	if text:
		$Control/Label.text = text
	player = playerRef

func start():
	show()
	$AnimationPlayer.play("zoom")
	get_tree().paused = true

func _on_Button_pressed():
	$ButtonPressSound.play()
	get_tree().paused = false
	print(player)
	if player:
		player.setPlayerToCheckpoint()
		hide()
	else:
		get_tree().reload_current_scene()
	
func _on_Button2_pressed():
	$ButtonPressSound.play()
	get_tree().quit()


func _on_Button_mouse_entered():
	$ButtonHoverSound.play()

func _on_Button2_mouse_entered():
	$ButtonHoverSound.play()
