extends Control

func _process(delta): #{
	if !$VideoPlayer.is_playing():
		$VideoPlayer.play()
