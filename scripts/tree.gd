extends Node2D

@onready var stick = preload("res://scenes/stick.tscn")

func shake():
	$AnimationPlayer.play("shake")
	var stick_instance = stick.instantiate()
	stick_instance.position = Vector2(position.x+randi_range(-96,96),position.y)
	
	stick_instance.velocity = Vector2(0,1)
	stick_instance.throwable = true
	get_parent().add_child(stick_instance)
