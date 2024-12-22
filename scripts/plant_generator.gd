extends Control

var x_range = 1760
var y_range = 1628
@onready var Plant1 = preload("res://scenes/plants/plant_1.tscn")
var plant_num = 1600
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	generate_plants()

func generate_plants():
	for i in plant_num:
		generate_single_plant()

func generate_single_plant():
	var plant_instance = Plant1.instantiate()
	plant_instance.position = random_position()
	plant_instance.z_index = 0
	var scale_multiplier = randi_range(5,6)
	plant_instance.scale = Vector2(scale_multiplier,scale_multiplier)
	plant_instance.plant_type = random_plant()
	add_child(plant_instance)

func random_position():
	var plant_x_pos = randi_range(-x_range,x_range)
	var plant_y_pos = randi_range(-y_range,y_range)
	return Vector2(plant_x_pos,plant_y_pos)
	
func random_plant():
	var plant_type_number = randi_range(1,3)
	return plant_type_number
