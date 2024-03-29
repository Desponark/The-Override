extends Control

func setup(videoStream, headline, button, explainationText):
	$Panel/VideoPlayer.stream = videoStream
	$Panel/Headline.text = headline
	$Panel/Explaination/ButtonIcon.texture = button
	$Panel/Explaination/Part2.text = explainationText
	
func start():
	get_tree().paused = true
	show()
	$Panel/VideoPlayer.play()
	$AudioStreamPlayer2D.play()
	
func _on_VideoPlayer_finished():
	$Panel/VideoPlayer.play()

func _on_Button_pressed():
	$ButtonPressSound.play()
	hide()
	$Panel/VideoPlayer.stop()
	get_tree().paused = false

func _on_Button_mouse_entered():
	$ButtonHoverSound.play()
