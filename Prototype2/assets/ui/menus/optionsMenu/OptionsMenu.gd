extends Control


onready var masterBusIndex = AudioServer.get_bus_index("Master")
onready var musicBusIndex = AudioServer.get_bus_index("Music")
onready var SFXBusIndex = AudioServer.get_bus_index("Sound Effects")
onready	var VoiceBusIndex = AudioServer.get_bus_index("Voice")

# TODO: add config file saving and loading

func _ready():
	$GridContainer/OptionButton.text = str(OS.get_window_size().x) + "x" + str(OS.get_window_size().y)
	$GridContainer/FullscreenChBx.pressed = OS.window_fullscreen
	$GridContainer/BorderlessChBx2.pressed = OS.window_borderless
	$GridContainer/VsyncChBx.pressed = OS.vsync_enabled
	
	$GridContainer/MasterHSlider.value = db2linear(AudioServer.get_bus_volume_db(masterBusIndex))
	$GridContainer/MusicHSlider.value = db2linear(AudioServer.get_bus_volume_db(musicBusIndex))
	$GridContainer/SFXHSlider3.value = db2linear(AudioServer.get_bus_volume_db(SFXBusIndex))
	$GridContainer/VoiceHSlider4.value = db2linear(AudioServer.get_bus_volume_db(VoiceBusIndex))
	
func _on_OptionButton_toggled(button_pressed):
	$ButtonPressSound.play()
	var values = $GridContainer/OptionButton.text.split_floats("x")
	var resolution = Vector2(values[0], values[1])
	OS.set_window_size(resolution)

func _on_FullscreenChBx_toggled(button_pressed):
	$ButtonPressSound.play()
	OS.window_fullscreen = button_pressed

func _on_BorderlessChBx2_toggled(button_pressed):
	$ButtonPressSound.play()
	OS.window_borderless = button_pressed

func _on_VsyncChBx_toggled(button_pressed):
	$ButtonPressSound.play()
	OS.vsync_enabled = button_pressed

func _on_MasterHSlider_value_changed(value):
	AudioServer.set_bus_volume_db(masterBusIndex, linear2db(value))

func _on_MusicHSlider_value_changed(value):
	AudioServer.set_bus_volume_db(musicBusIndex, linear2db(value))

func _on_SFXHSlider3_value_changed(value):
	AudioServer.set_bus_volume_db(SFXBusIndex, linear2db(value))

func _on_VoiceHSlider4_value_changed(value):
	AudioServer.set_bus_volume_db(VoiceBusIndex, linear2db(value))

func _on_Back_pressed():
	$ButtonPressSound.play()
	hide()

func _on_Button_mouse_entered():
	$ButtonHoverSound.play()
