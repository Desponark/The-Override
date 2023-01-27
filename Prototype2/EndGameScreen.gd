extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _on_Button_pressed():
	get_tree().reload_current_scene()
	
func _on_Button2_pressed():
	get_tree().quit()


func _on_FinishScreenTrigger_area_entered(area):
	visible = true

