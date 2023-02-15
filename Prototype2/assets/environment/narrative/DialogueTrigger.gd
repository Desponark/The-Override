extends Area2D

signal entered

func _on_DialogueTrigger_area_entered(area):
	emit_signal("entered")
	print("entered")
