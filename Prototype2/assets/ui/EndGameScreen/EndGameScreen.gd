extends Control

func _ready():
	visible = false

func _on_Button_pressed():
	get_tree().reload_current_scene()
	hide()
	
func _on_Button2_pressed():
	get_tree().quit()
	hide()

func _on_FinishScreenTrigger_area_entered(area):
	visible = true

