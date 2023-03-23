extends Control

signal creditsClosed

func _on_Back_pressed():
	$ButtonPressSound.play()
	emit_signal("creditsClosed")
	hide()

func _on_Button_mouse_entered():
	$ButtonHoverSound.play()

func start():
	$AnimationPlayer.play("start")
