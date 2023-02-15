extends AudioStreamPlayer2D

func _ready():
	$Voice.connect("entered", self, "play_audio")
	
func play_audio():
	$Voice.play()
