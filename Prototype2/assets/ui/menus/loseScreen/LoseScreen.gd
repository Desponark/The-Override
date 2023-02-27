extends Control

const saveGamePath = "user://savegame.save"

func _ready():
	visible = false

func setup(text):
	if text:
		$Control/Label.text = text

func start():
	show()
	$AnimationPlayer.play("zoom")
	get_tree().paused = true

func _on_ButtonLeft_pressed():
	$ButtonPressSound.play()
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_ButtonRight_pressed():
	$ButtonPressSound.play()
	get_tree().quit()

func _on_Button_mouse_entered():
	$ButtonHoverSound.play()
