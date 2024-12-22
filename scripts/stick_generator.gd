extends Control


var x_range = 1216
var y_range = 1024
@onready var Stick = preload("res://scenes/stick.tscn")
var stick_num = 13
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	generate_sticks()

func generate_sticks():
	for i in stick_num:
		generate_single_stick()

func generate_single_stick():
	var stick_instance = Stick.instantiate()
	stick_instance.position = random_position()
	stick_instance.z_index = 0
	stick_instance.stick_type = randi_range(1,3)
	add_child(stick_instance)

func random_position():
	var stick_x_pos = randi_range(-x_range,x_range)
	var stick_y_pos = randi_range(-y_range,y_range)
	return Vector2(stick_x_pos,stick_y_pos)
