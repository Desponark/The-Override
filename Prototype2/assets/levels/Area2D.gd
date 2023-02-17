extends Area2D


func _ready():
	$"../Control/Label4".visible = false

func _on_Area2D_body_entered(body):
	$"../Control/Label4".visible = true
