extends Control

#func _ready():
	#hide()
	
func _on_VideoPlayer_finished():
	$Panel/VideoPlayer.play()

func _on_Button_pressed():
	queue_free()
