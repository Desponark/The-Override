extends Control

func setup(videoStream, headline, button, explainationText):
	$Panel/VideoPlayer.stream = videoStream
	$Panel/Headline.text = headline
	$Panel/Explaination/ButtonIcon.texture = button
	$Panel/Explaination/Part2.text = explainationText
	
func start():
	$Panel/VideoPlayer.play()
	
func _on_VideoPlayer_finished():
	start()

func _on_Button_pressed():
	hide()
